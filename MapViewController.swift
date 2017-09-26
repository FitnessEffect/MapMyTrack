//
//  MapViewController.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 9/20/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var currentLocation2D =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var currentLocation = CLLocation()
    var previousLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var coordinateRegion:MKCoordinateRegion = MKCoordinateRegion()
    var buttonPressed = true
    var run = Run()
    var count = 0
    var arrayOfRuns = [Run]()
    var waitingForZoom = false
    var timer:Timer = Timer()
    var startTime:TimeInterval = TimeInterval()
    var savedRunKey:String = "savedRunKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "00:00:00"
        self.locationManager.startUpdatingLocation()
        getLocationUpdate()
        getCurrentLocationCoordinate()
        centerMapOnLocation(currentLocation)
        self.mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for _ in arrayOfRuns{
            _ = arrayOfRuns.popLast()
        }
    }
    
    func createPolyline(_ arrayOfPoints:[CLLocationCoordinate2D]) {
        let points = arrayOfPoints
        let geodesic = MKGeodesicPolyline(coordinates:points, count:run.path.count)
        mapView.add(geodesic)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.red
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
    
    func getLocationUpdate(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //Get location and center on current location when current location moves out of zone
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        if buttonPressed == false{
            run.path.append(locValue)
            if run.path.count > 1{
                createPolyline(run.path)
            }
        }
        let deltaLat = abs(currentLocation.coordinate.latitude - mapView.centerCoordinate.latitude) * 2
        let deltaLong = abs(currentLocation.coordinate.longitude - mapView.centerCoordinate.longitude) * 2
        
        let spanDeltaLat = mapView.region.span.latitudeDelta
        let spanDeltaLong = mapView.region.span.longitudeDelta
        if spanDeltaLong < deltaLong || spanDeltaLat < deltaLat{
            
            centerMapOnLocation(currentLocation)
            previousLocation.latitude = currentLocation.coordinate.latitude
            previousLocation.longitude = currentLocation.coordinate.longitude
        }
    }
    
    func getCurrentLocationCoordinate(){
        let loc = locationManager.location?.coordinate
        if loc?.latitude != nil{
            currentLocation2D.latitude = loc!.latitude
        }else{
            print("Could not get latitude for current location")
        }
        if loc?.longitude != nil{
            currentLocation2D.longitude = loc!.longitude
        }else{
            print("Could not get longitude for current location")
        }
        currentLocation = CLLocation(latitude: currentLocation2D.latitude, longitude: currentLocation2D.longitude)
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func slowCenterMapOnLocation(_ location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        MKMapView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }, completion: nil)
    }
    
    func slowCenterMapOnLocationUsingRegion(coordinateRegion:MKCoordinateRegion){
        
        MKMapView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }, completion: nil)
    }
    
    @objc func updateTimer(){
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        navigationItem.title = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    @IBAction func recordButton(_ sender: UIButton) {
        if buttonPressed == true{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MapViewController.updateTimer), userInfo: nil, repeats: true)
            
            startTime = Date.timeIntervalSinceReferenceDate
            
            run = Run()
            count += 1
            recordButtonOutlet.setTitle("Stop", for: UIControlState())
            recordButtonOutlet.setTitleColor(UIColor.red, for: UIControlState())
            buttonPressed = false
        }else if buttonPressed == false{
            timer.invalidate()
            self.locationManager.stopUpdatingLocation()
            if run.path.count > 1{
                getPathSize()
                let total = calculateDistance()
                run.result = navigationItem.title!
                run.name =  "Run " + String(count)
                run.distance = String(total)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "saveRun"), object: self, userInfo: [savedRunKey:run])
            }
            recordButtonOutlet.setTitle("Record", for: UIControlState())
            recordButtonOutlet.setTitleColor(UIColor(red: 0.0, green: 122/255, blue: 1, alpha: 1.0), for: UIControlState())
            buttonPressed = true
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func mapView(_ mapView: MKMapView,
                 regionDidChangeAnimated animated: Bool){
        if waitingForZoom{
            run.image = screenShotMethod()
            slowCenterMapOnLocation(currentLocation)
            waitingForZoom = false
        }
    }
    
    func getPathSize(){
        let middleIndex = run.path.count/2
        let middlePoint = run.path[middleIndex]
        
        let first = run.path.first
        let last = run.path.last
        
        let latitudeSpan = abs((last?.latitude)! - (first?.latitude)!)
        let longitudeSpan = abs((last?.longitude)! - (first?.longitude)!)
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeSpan + 0.003, longitudeDelta: longitudeSpan + 0.003)
        let coordinateRegion = MKCoordinateRegion(center: middlePoint, span: coordinateSpan)
        
        slowCenterMapOnLocationUsingRegion(coordinateRegion: coordinateRegion)
        waitingForZoom = true
    }
    
    func screenShotMethod()-> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func calculateDistance() -> String{
        var total = 0.0
        var runningTotalMeters = 0.0
        var runningTotalMiles = 0.0
        
        for i in (0...run.path.count-2){
            
            let myLocation1 = CLLocation(latitude: run.path[i].latitude, longitude: run.path[i].longitude)
            let myLocation2 = CLLocation(latitude: run.path[i+1].latitude, longitude: run.path[i+1].longitude)
            
            total = myLocation1.distance(from: myLocation2)
            runningTotalMeters = runningTotalMeters + total
            
            print(runningTotalMeters)
        }
        
        runningTotalMiles = runningTotalMeters * 0.000621371192
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        let runningTotalMilesFormatted = String(format: "%.2f", runningTotalMiles)
        return runningTotalMilesFormatted
    }
}
