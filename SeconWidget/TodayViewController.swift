//
//  TodayViewController.swift
//  SeconWidget
//
//  Created by Jackie Norstrom on 1/19/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var todayTasks = [Task]()
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return todayTasks.count
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableViewCell", for: indexPath) //as! TodayWidgetTableViewCell
        cell.textLabel?.text = "Hello"
//        let task = todayTasks[indexPath.row]
//        cell.task = task
        return cell
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        newLabel.text = "New World Order"
        todayTasks = CoreDataManager.shared.getAllTasks() ?? []
        tableView.reloadData()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
