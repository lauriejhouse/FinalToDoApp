//
//  TaskViewController.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import UIKit



class TaskViewController: UITableView, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    
    
    
    
    @IBOutlet weak var taskLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
        
        return cell
    }
    
    
    
    
    
    
}
