//
//  TaskDetailViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import CoreData

protocol TaskDetailViewControllerDelegate: class {
    func taskDetailViewControllerDidCancel(_ controller: TaskDetailViewController)
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: Task)
}

class TaskDetailViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext!
    
    var selectedGoal: Goal?
    var selectedTask: Task?
    lazy var tasks: [Task] = {
        if let tasks = selectedGoal?.tasks as? Set<Task> {
            return Array(tasks)
        } else {
            return []
        }
    }()
    
    weak var delegate: TaskDetailViewControllerDelegate?
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var completionSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
                let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
                self.navigationItem.rightBarButtonItem = rightBarButton
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        completionSwitch.isOn = selectedTask?.completed ?? false
        taskNameField.text = selectedTask?.taskName
        
        if let date = selectedTask?.dueDate as Date? {
            datePicker.date = date
        }
       
//        textField.becomeFirstResponder()
    }
    

    
    
    
    // MARK: - Action Methods
    
    @IBAction func didCompleteTask(_ sender: UISwitch) {
        selectedTask?.completed = sender.isOn
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.taskDetailViewControllerDidCancel(self)
//        print("Registered")
        //self.dismiss(animated: true, completion: nil)

    }
    
    //Need to use coredata manager here. possibly coredata.shared.save
    //Going to try and use CoreData Exaple.
    @IBAction func done(_ sender: Any) {
        /*
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
        task.taskName = textField.text!
        task.isChecked = false
 */
        if let goal = selectedGoal,
            let name = taskNameField.text {
            
            let dueDate = datePicker.date as NSDate
            
            if let task = selectedTask {
                task.completed = completionSwitch.isOn
                task.taskName = name
                task.dueDate = dueDate
                let _ = CoreDataManager.shared.save()
                delegate?.taskDetailViewController(self, didFinishAdding: task)
            } else if let task = CoreDataManager.shared.addTask(to: goal, with: name, dueDate: dueDate) {
                delegate?.taskDetailViewController(self, didFinishAdding: task)
            }
        }
        
        
        print("done")

    }
    
    
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*
    @objc func saveTask() {
        
        guard let goal = self.selectedGoal else { return }
        
        let alertController = UIAlertController(title: "Add Task", message: nil , preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert in
            let field = alertController.textFields![0] as UITextField
            guard let name = field.text else { return }
            
            guard let _ = CoreDataManager.shared.addTask(to: goal, with: name) else { return }
            guard let taskSet = goal.tasks, let tasks = Array(taskSet) as? [Task] else { return }
            self.tasks = tasks
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
 */
    
    
    
    
    
}
