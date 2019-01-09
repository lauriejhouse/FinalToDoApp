//
//  TaskViewController.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit
import Seam3
import CoreData


class TaskViewController: UITableViewController, UITextViewDelegate {
    
    //would var task make more sense? Since its task VC? Keep everything goal for now
    var goal: Goal?
    lazy var managedContext = {
        return CoreDataManager.shared.managedContext!
        
    }()
    
    

    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let taskItem = goal {
            if let tasks = taskItem.tasks {
                return tasks.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        guard let task = goal?.tasks?[indexPath.row] as? Task  else { return cell }
        configureText(for: cell, with: task)
        configureCheckmark(for: cell, with: task)
        return cell
    }

    
    
    
    
    
    
    func configureText(for cell: UITableViewCell, with task: Task) {
//        let taskLabel = cell.viewWithTag(2000) as! UILabel
        //look up the UIImage one. Or make a task cell.
        taskLabel.text = task.text
    }
    
    
}
