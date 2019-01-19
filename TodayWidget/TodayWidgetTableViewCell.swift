//
//  TodayWidgetTableViewCell.swift
//  TodayWidget
//
//  Created by Jackie Norstrom on 1/18/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit
import CoreData
import Seam3


class TodayWidgetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    var completed: Bool!
    var completedTasks = [String]() // save the task identifier
    
    var task: Task! {
        didSet {
            title.text = task.taskName
            completed = task.completed
            statusButton.isEnabled = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        statusButton.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func taskCompleted (_sender: UIButton) {
        completed = true
        statusButton.setImage(#imageLiteral(resourceName: "checked-custom"), for: .normal)
//        task.setDefaultsForCompletion()
        guard let managedContext = task.managedObjectContext else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Error during core data save in Widget: \(error.localizedDescription)")
        }
    }

}
