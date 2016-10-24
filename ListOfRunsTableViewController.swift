//
//  ListOfRunsTableViewController.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 9/22/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class ListOfRunsTableViewController: UITableViewController {
    
    var arrayOfRuns:[Run] = []
    var savedArrayOfRuns:[Run] = []
    var x = 0
    var resultTextField = UITextField()
    var savedRunsKey:String = "savedRunsKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editName(_ sender: UIButton) {
        
        let cellNum = sender.tag
        
        let alert = UIAlertController(title: "Edit Name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
        }
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler:{ (action) -> Void in
            
            let nameTextField = alert.textFields![0]
            self.arrayOfRuns[cellNum].name = nameTextField.text!
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(actions) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editTime(_ sender: UIButton) {
        
        let cellNum = sender.tag
        
        let alert = UIAlertController(title: "Edit Time", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
        }
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler:{ (action) -> Void in
            
            let resultTextField = alert.textFields![0]
            self.arrayOfRuns[cellNum].result = resultTextField.text!
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
        
        alert.addTextField { (textField) in
        }
        alert.addAction(UIAlertAction(title: "Save", style: .destructive, handler:{ (action) -> Void in
            
            let distanceTextField = alert.textFields![0]
            self.arrayOfRuns[cellNum].distance = distanceTextField.text!
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(actions) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfRuns.count
    }
    
    func passRuns(_ runs:[Run]){
        arrayOfRuns = runs
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runCell") as! CustomRunTableViewCell
        
        let run = arrayOfRuns[(indexPath as NSIndexPath).row]
        
        cell.runNameOutlet.text = run.name
        cell.runResultOutlet.text = run.result
        cell.runImageOutlet.image = run.image
        cell.runDistanceOutlet.text = run.distance + " miles"
        cell.setButtonTag(tag: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            arrayOfRuns.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            if arrayOfRuns.count == 0{
                self.dismiss(animated: true, completion: nil)
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func saveButton(_ button: UIButton) {
        var indexPath: NSIndexPath!
        
        if let superview = button.superview {
            if let cell = superview.superview as? CustomRunTableViewCell {
                indexPath = tableView.indexPath(for: cell) as NSIndexPath!
            }
        }
        
        let cellNum = indexPath.row
        
        savedArrayOfRuns.append(arrayOfRuns[cellNum])
        arrayOfRuns.remove(at: cellNum)
        tableView.reloadData()
        
        if arrayOfRuns.count == 0{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "savedRuns"), object: self, userInfo: [savedRunsKey:savedArrayOfRuns])
            dismiss(animated: true, completion: nil)
        }
    }
}
