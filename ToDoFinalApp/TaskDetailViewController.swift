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
    
    var selectedGoal: Goal?
    var selectedTask: Task?
    lazy var tasks: [Task]? = {
        return selectedGoal?.tasks
    }()
    var tasksCount: Int?
   // var checkedItems: Int?

    
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
       
        taskNameField.becomeFirstResponder()
    }
    

    
    
    
    // MARK: - Action Methods
    
    @IBAction func didCompleteTask(_ sender: UISwitch) {
        selectedTask?.completed = sender.isOn
        //guard let tasksCount = selectedGoal?.tasks.count else { return }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.taskDetailViewControllerDidCancel(self)


    }
    
   
    @IBAction func done(_ sender: Any) {
  
        if let goal = selectedGoal,
            let name = taskNameField.text {
            
            let dueDate = datePicker.date as NSDate
            
            if let task = selectedTask {
                task.completed = completionSwitch.isOn
                task.taskName = name
                task.dueDate = dueDate
                delegate?.taskDetailViewController(self, didFinishAdding: task)
                CloudKitManager.shared.editTask(task: task)
            } else {
                
                CloudKitManager.shared.addTask(to: goal, with: name, dueDate: dueDate, completion: { task in
                    self.delegate?.taskDetailViewController(self, didFinishAdding: task!)
                })
            }
        }
        
        
        print("done")

    }
    
    
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
    
    
    
    
}
