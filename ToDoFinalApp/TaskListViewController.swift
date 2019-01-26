//
//  TaskListViewController.swift
//  CoreDataSyncExample
//
//  Created by Frankie Cleary on 12/4/18.
//  Copyright © 2018 FbombMedia. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {
    
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
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].taskName
        return cell
    }
}
