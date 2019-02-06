//
//  GoalTableViewCell.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/11/18.
//  Copyright © 2018 LAS. All rights reserved.
//

//Due date stuff is in coreData Manager


import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var checkedItems: Int?


    
    
    
    @IBAction func animateButton(sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    // This one is also linked ot MainGoalsVC. Do I need both?
    func configureIncomingGoal (incomingGoal: Goal) {
        goalLabel.text = incomingGoal.goalName
        
        if let taskSet = incomingGoal.tasks, let tasks = Array(taskSet) as? [Task] {

            let allTasksCount = tasks.count
            let completedTasksCount = tasks.filter({ $0.completed }).count
            //use these two counts to do your label logic

            if allTasksCount == 0 {
                taskCountLabel?.text = NSLocalizedString("Select Goal To Add New Tasks.", comment: "")
            } else if completedTasksCount == 0 {
                taskCountLabel?.text = "\(allTasksCount) \(NSLocalizedString("to complete", comment:""))"
            } else if completedTasksCount == allTasksCount {
                taskCountLabel?.text = NSLocalizedString("All Tasks Completed! You Did It", comment: "")
            } else {
                taskCountLabel?.text = "\(completedTasksCount) \(NSLocalizedString("of", comment:"")) \(allTasksCount) \(NSLocalizedString("completed", comment:""))"
                
            }

        }
        
      

        self.iconImage.image = UIImage(named: incomingGoal.iconName ?? "No Icon" )
        
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
