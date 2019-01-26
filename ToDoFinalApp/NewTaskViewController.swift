//
//  NewTaskViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import CoreData

protocol NewTaskViewControllerDelegate: class {
    func newTaskViewControllerDidCancel(_ controller: NewTaskViewController)
    func newTaskViewController(_ controller: NewTaskViewController, didFinishAdding task: Task)
}

class NewTaskViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext!
    
    weak var delegate: NewTaskViewControllerDelegate?
    @IBOutlet weak var textField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addTask))
                self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        textField.becomeFirstResponder()
    }
    

    
    
    
    // MARK: - Action Methods
    
    @IBAction func cancel(_ sender: Any) {
//        delegate?.newTaskViewControllerDidCancel(self)
//        print("Registered")
        self.dismiss(animated: true, completion: nil)

    }
    
    //Need to use coredata manager here. possibly coredata.shared.save
    //Going to try and use CoreData Exaple.
//    @IBAction func done(_ sender: Any) {
////        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
////        task.taskName = textField.text!
////        task.isChecked = false
////        delegate?.newTaskViewController(self, didFinishAdding: task)
////        print("done")
//
//    }
    
    
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    var selectedGoal: Goal?
    lazy var tasks: [Task] = {
        if let tasks = selectedGoal?.tasks as? Set<Task> {
            return Array(tasks)
        } else {
            return []
        }
    }()

    
    
    @objc func addTask() {
        
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
    
    
    
    
    
}
