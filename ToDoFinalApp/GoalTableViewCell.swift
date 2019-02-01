//
//  GoalTableViewCell.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/11/18.
//  Copyright © 2018 LAS. All rights reserved.
//



import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    //Instead of using default on line 28, use this one. to populate the image.
    //use self.iconImage. insted of self.imageView. Will remove using default and will use custom property on line 18.
    
//    @IBAction func buttonTouched(_ sender: UIButton) {
//        UIButton.animate(withDuration: 0.2,
//                         animations: {
//                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
//        },
//                         completion: { finish in
//                            UIButton.animate(withDuration: 0.2, animations: {
//                                sender.transform = CGAffineTransform.identity
//                            })
//        })
//    }
    
    
    
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
        
      
        
        
//        taskCountLabel.text = "\(goal.tasks?.count ?? 0)"
        //or
//        taskCountLabel.text = String(describing: goal.tasks?.count ?? 0)
        
//        self.imageView?.image = UIImage(named: incomingGoal.iconName ?? "No Icon") //using the iboutlet instead of this.
        self.iconImage.image = UIImage(named: incomingGoal.iconName ?? "No Icon" )
        
//            goalLabel.text =  "\(formattedUnitsSold()) \(NSLocalizedString("units", comment: ""))"
        
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
