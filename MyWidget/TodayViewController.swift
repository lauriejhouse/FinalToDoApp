//
//  TodayViewController.swift
//  MyWidget
//
//  Created by Frankie Cleary on 1/21/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todayTasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.shared.managedContext = self.persistentContainer.viewContext
        todayTasks = CoreDataManager.shared.getAllTasks() ?? []
        tableView.reloadData()
    }
    
    @IBAction func openAppButtonTapped(_ sender: UIButton) {
        let url: URL? = URL(string: "ToDoFinalApp:")!
        if let appurl = url {
            self.extensionContext!.open(appurl, completionHandler: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableViewCell", for: indexPath) as! TodayTableViewCell
//        cell.textLabel?.text = todayTasks[indexPath.row].taskName
        let task = todayTasks[indexPath.row]
        cell.task = task
        return cell
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
            preferredContentSize = CGSize(width: 0, height: 400)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    

    @IBAction func openAppButton(_ sender: UIButton) {
        let url: URL? = URL(string: "ToDoFinalApp:")!
        if let appurl = url {
            self.extensionContext!.open(appurl, completionHandler: nil)
        }

    }
    
    //From example app for today due dates
//    private func predicateForToday() -> NSPredicate {
//        let now = Date()
//        let startOfDay = now.startOfDay as NSDate
//        let endOfDay = now.endOfDay as NSDate
//        return NSPredicate(format: "dueDate >= %@ AND dueDate <= %@ ", startOfDay, endOfDay)
//    }
//
//    private func predicateNotCompleted() -> NSPredicate {
//        return NSPredicate(format: "%K == NO", #keyPath(Task.completed))
//    }
  
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoFinalApp")
        
        let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.las.ToDoFinalApp.TodayWidget")
        
        if let applicationDocumentsDirectory = directory {
            
            let url = applicationDocumentsDirectory.appendingPathComponent("ToDoFinalApp.sqlite")
            
            let storeDescription = NSPersistentStoreDescription(url: url)
            
            container.persistentStoreDescriptions=[storeDescription]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }
        
        fatalError("Unable to access documents directory")
    }()
    
    
}





