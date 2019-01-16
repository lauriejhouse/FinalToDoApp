//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Jackie Norstrom on 1/16/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import Seam3
import os.log

//may need the date getter pod file. to make the dates work correctly.

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var todayTasks = [Task]()

    
    @IBOutlet weak var tableView: UITableView!
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        tableView.dataSource = self
        tableView.delegate = self
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    
    
    

    
    
    
    
    
    
    
   
    
    
    
}


extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTasks.count
    }
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableViewCell", for: indexPath) as! TodayWidgetTableViewCell
        let task = todayTasks[indexPath.row]
        cell.task = task
        return cell
    }

}
