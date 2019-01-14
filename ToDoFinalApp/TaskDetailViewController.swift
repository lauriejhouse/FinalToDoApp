//
//  GoalDetailViewController.swift
//  CoreDataSyncExample
//
//  Created by Frankie Cleary on 12/4/18.
//  Copyright © 2018 FbombMedia. All rights reserved.
//

import UIKit

class TaskDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UILabel!
    

    var selectedGoal: Goal?
    
    lazy var tasks: [Task] = {
        if let tasks = selectedGoal?.tasks as? Set<Task> {
            return Array(tasks)
        } else {
            return []
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        self.navigationItem.rightBarButtonItem = rightBarButton
        //Add the name of the goal that has a task?
//        self.nameField.text = self.selectedGoal?.goalName
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].taskName
        return cell
    }
    
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
    
    @objc func editTask(task: Task) {
        
        guard let goal = self.selectedGoal else { return }

        let alertController = UIAlertController(title: "Edit Task", message: nil , preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = task.taskName
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert in
            let field = alertController.textFields![0] as UITextField
            guard let name = field.text else { return }
            task.taskName = name
            
            let _ = CoreDataManager.shared.save()
            
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
