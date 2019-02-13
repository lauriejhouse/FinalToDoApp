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
import os.log



class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    //Due date stuff is in coreData Manager
    
    @IBOutlet weak var tableView: UITableView!
    
    var todayTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.shared.managedContext = self.persistentContainer.viewContext
        todayTasks = CoreDataManager.shared.getAllTasks() ?? []
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
    }
    
    //    @IBAction func openAppButtonTapped(_ sender: UIButton) {
    //        let url: URL? = URL(string: "ToDoFinalApp:")!
    //        if let appurl = url {
    //            self.extensionContext!.open(appurl, completionHandler: nil)
    //        }
    //    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: 400)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Does the gettodaytasks go here?
        let _ = CoreDataManager.shared.getAllTasksForToday()
        //        tableView.reloadData()
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableViewCell", for: indexPath) //as! TodayWidgetTableViewCell
        cell.textLabel?.text = todayTasks[indexPath.row].taskName
        return cell
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let _ = CoreDataManager.shared.getAllTasksForToday()
        tableView.reloadData()
        
        
        completionHandler(NCUpdateResult.newData)
        
        
    }
    
    
    //    @IBAction func openButtonTapped(_ sender: UIButton) {
    //        let url: URL? = URL(string: "ToDoFinalApp:")!
    //        if let appurl = url {
    //            self.extensionContext!.open(appurl, completionHandler: nil)
    //        }
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

