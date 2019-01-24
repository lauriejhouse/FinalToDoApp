//
//  TodayTableViewCell.swift
//  MyWidget
//
//  Created by Jackie Norstrom on 1/24/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import CoreData

//Put a segue to go to the taskVC?
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
    
    @IBAction func taskCompleted(_ sender: UIButton) {
        completed = true
        taskButton.setImage(#imageLiteral(resourceName: "checked-custom"), for: .normal)
//        task.setDefaultsForCompletion()
        guard let managedContext = task.managedObjectContext else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Error during core data save in Widget: \(error.localizedDescription)")
        }
    }
    
    
    

}
