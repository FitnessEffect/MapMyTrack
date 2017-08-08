//
//  SavedRunsViewController.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 9/27/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class SavedRunsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var savedRuns = [Run]()
    var x = 0
    var filteredRuns = [Run]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveRuns()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        savedRuns.removeAll()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.resultSearchController.isActive{
            return filteredRuns.count
        }else{
            return savedRuns.count
        }
    }
    
    func passRun(runs:[Run]){
        for run in runs{
            savedRuns.append(run)
        }
    }
    
    //Save Runs to file
    func saveRuns(){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let path: AnyObject = paths[0] as AnyObject
        let arrPath = path.appending("/runs.plist")
        NSKeyedArchiver.archiveRootObject(savedRuns, toFile: arrPath)
    }
    
    //Retrieve Runs from file
    func retrieveRuns(){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let path: AnyObject = paths[0] as AnyObject
        let arrPath = path.appending("/runs.plist")
        if let tempRunArr: [Run] = NSKeyedUnarchiver.unarchiveObject(withFile: arrPath) as? [Run] {
            for run in tempRunArr{
                savedRuns.append(run)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runSavedCell") as! CustomRunTableViewCell
        let run = savedRuns[(indexPath as NSIndexPath).row]
        if self.resultSearchController.isActive{
            cell.runNameOutlet.text = filteredRuns[indexPath.row].name
            cell.runImageOutlet.image = filteredRuns[indexPath.row].image
            cell.runResultOutlet.text = filteredRuns[indexPath.row].result
            cell.runDistanceOutlet.text = filteredRuns[indexPath.row].distance
        }else{
            cell.runNameOutlet.text = run.name
            cell.runResultOutlet.text = run.result
            cell.runImageOutlet.image = run.image
            cell.runDistanceOutlet.text = run.distance + " miles"
            cell.setButtonTag(tag: indexPath.row)
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredRuns.removeAll(keepingCapacity: false)
        for element in savedRuns{
            if(element.name.lowercased().hasPrefix(searchController.searchBar.text!.lowercased()))
            {
                filteredRuns.append(element)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func editName(_ sender: UIButton) {
        let cellNum = sender.tag
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in}
        
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler:{ (action) -> Void in
            let nameTextField = alert.textFields![0]
            self.savedRuns[cellNum].name = nameTextField.text!
            self.saveRuns()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(actions) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editResult(_ sender: UIButton) {
        let cellNum = sender.tag
        let alert = UIAlertController(title: "Edit Time", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in}
        
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler:{ (action) -> Void in
            let resultTextField = alert.textFields![0]
            self.savedRuns[cellNum].result = resultTextField.text!
            self.saveRuns()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(actions) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editDistance(_ sender: UIButton) {
        let cellNum = sender.tag
        let alert = UIAlertController(title: "Edit Distance", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in}
        
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler:{ (action) -> Void in
            let distanceTextField = alert.textFields![0]
            self.savedRuns[cellNum].distance = distanceTextField.text!
            self.saveRuns()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(actions) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            savedRuns.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            saveRuns()
            tableView.reloadData()
        }
    }
}
