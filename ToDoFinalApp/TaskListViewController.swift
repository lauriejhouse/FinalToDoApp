//
//  TaskListViewController.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK


class TaskListViewController: UITableViewController, UITextViewDelegate {
  
    var selectedGoal: Goal?
    
    var tasks: [Task]? {
        return selectedGoal?.tasks
        //need to fetch actual tasks from references
        //return selectedGoal?.tasks ?? []
        // return []
    }
    

    
    func addTwoNumbers(a: Int, b: Int) -> Int {
        return a + b
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    //Original
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
//        guard let task = selectedGoal?.tasks?[indexPath.row] as? Task else {return cell}
        cell.textLabel?.text = tasks?[indexPath.row].taskName
       // let laguage = tasks?[(indexPath as NSIndexPath).row]

//configureCheckmark(for: cell, with: tasks)
//        cell.textLabel!.text = laguage.name
       // cell.accessoryType = laguage.enabled ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = tasks?[indexPath.row] {
            self.performSegue(withIdentifier: "editTask", sender: task)
        }
    }
    
    //end example checkmark.
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let name = textField.text {
            self.selectedGoal?.goalName = name
        }
        
        return true
    }
    
    // MARK: - Alerts
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? TaskDetailViewController {
            
            if segue.identifier == "editTask" {
                if let indexPath = tableView.indexPathForSelectedRow,
                    let tasks = tasks,
                    indexPath.row < tasks.count {
                    controller.selectedTask = tasks[indexPath.row]
                }
                /*
                if let task = sender as? Task,  {
                    controller.selectedTask = task
                    } else {
                    
                }
                */
                
                /*
                if let goal = selectedGoal {
                    CloudKitManager.shared.addTask(to: goal, with: "New task", dueDate: Date() as NSDate) { task in
                        controller.selectedTask = task
                    }
                }
                */
               
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

