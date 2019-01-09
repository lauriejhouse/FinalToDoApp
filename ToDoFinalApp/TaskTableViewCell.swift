//
//  TaskTableViewCell.swift
//  ToDoFinalApp
//
//  Created by Jackie Norstrom on 1/9/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {


    @IBOutlet weak var taskLabel: UILabel!
    

    
    func configureTask (incomingGoal: Task) {
        taskLabel.text = incomingGoal.taskName
    }
    
    

}
