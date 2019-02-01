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
    var tasksCount: Int?
    var checkedItems: Int?

    
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
        guard let tasksCount = selectedGoal?.tasks?.count else { return }
        
        fetchCheckedItems(with: selectedGoal!)

        
        //this doesn't change the goal cell text.
        
        
//        if let checkedItems = checkedItems {
//            if tasksCount == 0 {
//                taskNameField.text = "Select Goal!"
//            } else if checkedItems == 0 {
//                taskNameField.text = "Get Started! \(tasksCount) To Go!"
//            } else if checkedItems == tasksCount {
//                taskNameField.text = "All Tasks Completed!"
//            } else {
//                taskNameField.text = "\(checkedItems) of \(tasksCount) Completed"
//            }
//        }
        
    }
    
    //Says managed context is nil when its not.
    func fetchCheckedItems(with goal: Goal) {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.predicate = NSPredicate(format: "goal == %@ AND enabled == %@ ", goal, NSNumber(booleanLiteral: true))
        
        do {
            let results = try managedContext.fetch(request)
            checkedItems = results.count
        } catch let error as NSError {
            print(error)
        }
        
    }

    
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.taskDetailViewControllerDidCancel(self)
//        print("Registered")
        //self.dismiss(animated: true, completion: nil)

    }
    
   
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
   
    
    
    
    
    
}
