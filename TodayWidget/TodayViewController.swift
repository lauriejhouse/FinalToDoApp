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
//Need due date, compeltion date? What about start date? and reminder date?

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var todayTasks = [Task]()
    
    let coreDataStack = CoreDataStack.shared(modelName: ModelName.ToDo)


    
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
        do {
            try readFromCoreData()
        } catch {
            completionHandler(NCUpdateResult.failed)
            return
        }
        
        guard !todayTasks.isEmpty else {
            print("---- Why return no data ??? ----- ")
            completionHandler(NCUpdateResult.noData)
            return
        }
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        tableView.reloadData()
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func readFromCoreData() throws {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let todayPredicate =  predicateForToday()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [todayPredicate, predicateNotCompleted()])
        let dueDateSort = NSSortDescriptor(key: #keyPath(Task.dueDate), ascending: true)
        let titleSort = NSSortDescriptor(key: #keyPath(Task.taskName), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [dueDateSort, titleSort]
        do {
            todayTasks = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            os_log("Error when fetch from coreData from Widget: %@", error.debugDescription)
            throw error
        }
    }
    
    private func predicateForToday() -> NSPredicate {
        let now = Date()
        let startOfDay = now.startOfDay as NSDate
        let endOfDay = now.endOfDay as NSDate
        return NSPredicate(format: "dueDate >= %@ AND dueDate <= %@ ", startOfDay, endOfDay)
    }
    
    private func predicateNotCompleted() -> NSPredicate {
        return NSPredicate(format: "%K == NO", #keyPath(Task.completed))
    }
    
    @IBAction func openAppButtonTapped(_ sender: UIButton) {
        let url: URL? = URL(string: "Todododo:")!
        if let appurl = url {
            self.extensionContext!.open(appurl, completionHandler: nil)
        }
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
