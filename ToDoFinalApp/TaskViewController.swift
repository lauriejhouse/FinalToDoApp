//
//  TaskViewController.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit



class TaskViewController: UITableViewController, UITextViewDelegate {
    
    //would var task make more sense? Since its task VC? Keep everything goal for now
    var goal: Goal?
    
    
    
    
    @IBOutlet weak var taskLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        return cell
    }
    
    
    
    
    
    
}
