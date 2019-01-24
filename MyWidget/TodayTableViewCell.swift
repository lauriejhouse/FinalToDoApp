//
//  TodayTableViewCell.swift
//  MyWidget
//
//  Created by Jackie Norstrom on 1/24/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import CoreData

class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var taskButton: UIButton!//set up button to go to taskVC of correct task.
    var completed: Bool!
    
    var task: Task! {
        didSet {
            title.text = task.taskName
            completed = task.completed
            taskButton.isEnabled = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        taskButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        taskButton.isEnabled = false
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
