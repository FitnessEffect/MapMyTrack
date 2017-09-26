//
//  TabBarController.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 10/8/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var runs = [Run]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarController.receiveRuns), name: NSNotification.Name(rawValue: "saveRun"), object: nil)
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController){
        if tabBar.selectedItem?.title == "Results"{
            let nav = tabBarController.selectedViewController as! UINavigationController
            let vc = nav.topViewController as! SavedRunsViewController
            vc.passRun(runs: runs)
            runs.removeAll()
        }
    }
    
    @objc func receiveRuns(_ notification: Notification){
        let info:[String:Run] = (notification as NSNotification).userInfo as! [String:Run]
        let myPassedRun = info["savedRunKey"]
        runs.append(myPassedRun!)
    }
}
