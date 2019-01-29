//
//  TaskListViewController.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit
import Seam3
import CoreData
import Flurry_iOS_SDK





class TaskListViewController: UITableViewController, UITextViewDelegate {
    
  
    var selectedGoal: Goal?
    
    var tasks: [Task] {
        if let tasks = selectedGoal?.tasks as? Set<Task> {
            return Array(tasks)
        } else {
            return []
        }
    }
    
    struct Option {
//        let name : String
        var enabled : Bool
        
        init( _ enabled : Bool) {
//            self.name = name
            self.enabled = enabled
        }
    }
    
//  @IBOutlet weak var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
//        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //Add the name of the goal that has a task?
//                self.selectedGoal.text = self.selectedGoal?.goalName
        
        //Trying to save to cloudkit.
        CloudKitManager.shared.triggerSyncWithCloudKit()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: SMStoreNotification.SyncDidFinish), object: nil, queue: nil) { notification in
            
            if notification.userInfo != nil {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.smStore?.triggerSync(complete: true)
            }
            //commenting out to get rid of the error.
            //                        self.managedContext.refreshAllObjects()
            //
            //Need to get tasks working correctly.
//            DispatchQueue.main.async {
//                self.tasks = CoreDataManager.shared.getAllGoals() ?? []
//                self.tableView.reloadData()
//            }
        }
    }
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let taskItem = tasks {
//            if let tasks = taskItem.tasks {
//                return tasks.count
//            }
//        }
        return tasks.count
    }
    
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
//        //commenting that out didn't do much, still need to fix the edit button.
////        guard let task = goal?.tasks?[indexPath.row] as? Task  else
////        {
////
////            return cell
////
////        }
//        //These can be added to taskVC later.
////        configureText(for: cell, with: task)
////        configureCheckmark(for: cell, with: task)
//        return cell
    
//    }
    
    //commenting out for now because it doesnt go with the example app.
//    func configureText(for cell: TaskTableViewCell, with task: Task) {
//        //        let taskLabel = cell.viewWithTag(2000) as! UILabel
//        //look up the UIImage one. Or make a task cell.
//        cell.taskLabel.text = task.taskName
//    }


    
    
    
    
    //Original
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
//        guard let task = selectedGoal?.tasks?[indexPath.row] as? Task else {return cell}
        cell.textLabel?.text = tasks[indexPath.row].taskName
        let laguage = tasks[(indexPath as NSIndexPath).row]

//configureCheckmark(for: cell, with: tasks)
//        cell.textLabel!.text = laguage.name
        cell.accessoryType = laguage.enabled ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none

        return cell
    }
    
    
    //adding from get it done example app
    
    //
    //
//    func configureCheckmark(for cell: UITableViewCell, with task: Task) {
//
//        let imageView = cell.viewWithTag(3000) as! UIImageView
//
//
//        if task.isChecked != true {
//            imageView.image = #imageLiteral(resourceName: "No Icon")
//        } else {
//            imageView.image = #imageLiteral(resourceName: "checked-3")
//        }
//    }
   
//From Get it done
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
//        guard let task = selectedGoal?.tasks?[indexPath.row] as? Task  else { return cell }
//
//        cell.textLabel?.text = tasks[indexPath.row].taskName
//        configureCheckmark(for: cell, with: task)
//        return cell
//    }
    
    
    //works but doesn't save the checkbox or update the number to complete. Can only check one off at atime.
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if let oldIndex = tableView.indexPathForSelectedRow {
//            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
//        }
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//
//        return indexPath
//    }
    
    //from an example app trying to select multiple check marks.
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // mark the cell
        /*
        if self.tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        // save the value in the array
        let index = (indexPath as NSIndexPath).row
        tasks[index].enabled = !tasks[index].enabled
        let _ = CoreDataManager.shared.save()
 */
        let task = tasks[indexPath.row]
        self.performSegue(withIdentifier: "editTask", sender: task)

    }
    //end example checkmark.
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let name = textField.text {
            self.selectedGoal?.goalName = name
            let _ = CoreDataManager.shared.save()
        }
        
        return true
    }
    
    // MARK: - Alerts
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? TaskDetailViewController {
            
            if let task = sender as? Task, segue.identifier == "editTask" {
                controller.selectedTask = task
            }
            
            controller.selectedGoal = selectedGoal
            controller.delegate = self
        }
    }
    
}

extension TaskListViewController: TaskDetailViewControllerDelegate {
    func taskDetailViewControllerDidCancel(_ controller: TaskDetailViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: Task) {
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}

