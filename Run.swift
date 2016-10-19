//
//  Run.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 9/20/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import Foundation
import MapKit

let name = "name"
let result = "result"
let distance = "distance"
let path = "path"
let image = "image"

class Run: NSCoder {
    var name:String
    var distance:String
    var result:String
    var path:[CLLocationCoordinate2D]
    var image:UIImage
    
    //default initializer
    override init(){
        name = ""
        distance = ""
        result = ""
        path = []
        image = UIImage(named: "No_Image_Available.png")!
    }
    
    //overload initializer
    init(name:String, distance:String, result:String, path:[CLLocationCoordinate2D], image:UIImage){
        self.name = name
        self.distance = distance
        self.result = result
        self.path = []
        self.image = image
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        aCoder.encode(name, forKey:"name")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(result, forKey:  "result")
        aCoder.encode(image, forKey: "image")
    }
    
    init (coder aDecoder: NSCoder!) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.distance = aDecoder.decodeObject(forKey: "distance") as! String
        self.result = aDecoder.decodeObject(forKey: "result") as! String
        self.path = [CLLocationCoordinate2D]()
        self.image = aDecoder.decodeObject(forKey: "image") as! UIImage
    }
}
