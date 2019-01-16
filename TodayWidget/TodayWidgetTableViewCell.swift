//
//  TodayWidgetTableViewCell.swift
//  ToDoFinalApp
//
//  Created by Jackie Norstrom on 1/16/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import CoreData
import Seam3

//creat today widget to show which tasks are due today.
//Need to make a date picker in the storyboard.
class TodayWidgetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var statusButton: UIButton!
    
    var completed: Bool!
    
    var task: Task! {
        didSet {
            title.text = task.taskName
            completed = task.isChecked
            statusButton.isEnabled = true
        }
    }
    

    var completedTasks = [String]() // save the task identifier
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        statusButton.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }



}
