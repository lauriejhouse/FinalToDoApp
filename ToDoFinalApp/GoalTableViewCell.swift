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
        
//        if let taskSet = incomingGoal.tasks, let tasks = Array(taskSet) as? [Task] {
//
//            let allTasksCount = tasks.count
//            let completedTasksCount = tasks.filter({ $0.completed }).count
//            //use these two counts to do your label logic
//        }
        
      

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
