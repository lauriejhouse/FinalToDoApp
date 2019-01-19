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
    
    
    func configure (incomingGoal: Goal) {
        goalLabel.text = incomingGoal.goalName
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
