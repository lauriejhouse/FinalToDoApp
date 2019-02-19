//
//  ViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//




import UIKit
import Foundation
import TableViewDragger
import CloudKit
import GoogleMobileAds
import Flurry_iOS_SDK

class MainGoalsViewController: UITableViewController, UINavigationControllerDelegate {
    
//For TableViewDragger CocoaPod
    var dragger: TableViewDragger!
    
    @IBOutlet weak var bannerView: GADBannerView!


    //For CloudKit
    let container = CKContainer.default()
    let record = CKRecord(recordType: "Goal")
    lazy var publicDB: CKDatabase! = {
        let DB = self.container.publicCloudDatabase
        return DB
    }()

    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 75
    var goalItems: [Goal]? = []
    var checkedItems: Int?
    
    
    
    
//    @IBOutlet weak var taskButton: UIButton!
    
    //save record to database: record.setobjectforkey("fieldname")
    //key is always field name from cloudKitDB
//CKModififyreocrdsoperation - class name. pass in records that you wanna save as an array.
    //completion block.
    //publicdatabase.saverecord - for one record at a time
    //CKModifyRecordsOperation - save batch records.



    // MARK: - BPs
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.rowHeight = rowHeight

        selectNewGoal()
        dragger = TableViewDragger(tableView: tableView)
        dragger.dataSource = self
        dragger.delegate = self
        dragger.alphaForCell = 0.7
        dragger.opacityForShadowOfCell = 1

        //example ad
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        //my ad using toDoFinalApp - it never shows any adverts
//        bannerView.adUnitID = "ca-app-pub-5462116334906512/1055770455"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        navigationController?.delegate = self

        CloudKitManager.shared.getAllGoals() { goals in
           self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    

    
    
    
    
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudKitManager.shared.goals.count
        /*
        if let goalItems = goalItems {
            let parameters = ["Goal" : goalItems]
            Flurry.logEvent("Goal-Count", withParameters: parameters)
            return goalItems.count
            
        }
        return 1
        */
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath  ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalTableViewCell
        
        let goals = CloudKitManager.shared.goals
        if indexPath.row < goals.count {
            let goal = goals[indexPath.row]
            configure(cell, with: goal)
        }
        /*
        if let goalItems = goalItems {
            let goalItem = goalItems[indexPath.row]
            configure(cell, with: goalItem)
        }
 */
        
        if let button = cell.viewWithTag(999) as? UIButton {
            button.tag = indexPath.row
        }
 
        return cell
    }
    
    
  
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //To move goal items. Being replaced by cocoapod.
    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.goalItems?[sourceIndexPath.row]
//        goalItems?.remove(at: sourceIndexPath.row)
//        goalItems?.insert(movedObject!, at: destinationIndexPath.row)
//        do {
//            try self.managedContext.save()
//        } catch {
//            print("Rows could not be saved")
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {


            let deleteAlertController = UIAlertController(title: NSLocalizedString("Delete Goal?", comment: ""), message:NSLocalizedString("This will remove your goal and tasks.", comment: "alert action"), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment:""), style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (delete) in



//                guard let goalToDelete = self.goalItems?[indexPath.row] else { return }
//              self.goalItems?.remove(at: indexPath.row)
                let goal = CloudKitManager.shared.goals[indexPath.row]


                //call to CK to delete
   
                CloudKitManager.shared.deleteGoal(with: goal, completion: {
                    CloudKitManager.shared.getAllGoals() { goals in
                        self.tableView.reloadData()
                    }
                })
                
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                self.selectNewGoal()

                //plug in delete function here

            }

            deleteAlertController.addAction(cancelAction)
            deleteAlertController.addAction(deleteAction)
            present(deleteAlertController, animated: true, completion: nil)

        }
    }
    
    
    
    
    
   
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    
    
    

    
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddGoal" {
            let nav = segue.destination as! UINavigationController
            let _ = nav.topViewController as! NewGoalViewController
            
            
        } else if segue.identifier == "EditGoal" {
            let nav = segue.destination as! UINavigationController
            let goalVC = nav.topViewController as! NewGoalViewController
            
            if let button = sender as? UIButton {
                let goals = CloudKitManager.shared.goals
                if button.tag < goals.count {
                    goalVC.goalToEdit = goals[button.tag]
                }
                //goalVC.goalToEdit = goalItems?[button.tag]
            }
        } else if segue.identifier == "ShowGoal" {
            let goals = CloudKitManager.shared.goals
            if let indexPath = tableView.indexPathForSelectedRow,
                indexPath.row < goals.count,
                let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? TaskListViewController
                {
                    let goal = goals[indexPath.row]
                    vc.selectedGoal = goal
                    if goal.tasks.count < 1 {
                        vc.title = NSLocalizedString("Your Tasks Will Appear Here.", comment: "")
                    } else {
                        vc.title = goal.goalName
                    }
            }
            
        }
    }
    
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomNavigationAnimator()
    }
    
    
    // MARK: - Custom Methods

    //This changes the MainGoal Cell.
    func configure(_ cell: GoalTableViewCell, with goal: Goal) {
//        let icon = cell.viewWithTag(10) as? UIImageView
        
        //maybe this is why its not updating correctly  
        let tasksDoneLabel = cell.taskCountLabel
        
        
       // guard let tasksCount = goal.tasks?.count else { return }
        let tasksCount = goal.tasks.count
        //call tasksdonelabel from the goal view cell
        
//        It 'controls' the text for tasks.
        if let checkedItems = checkedItems {
            if tasksCount == 0 {
                tasksDoneLabel?.text = NSLocalizedString("Select Goal To Add New Tasks.", comment: "")
            } else if checkedItems == 0 {
                tasksDoneLabel?.text = "\(tasksCount) \(NSLocalizedString("to complete", comment:""))"
            } else if checkedItems == tasksCount {
                tasksDoneLabel?.text = NSLocalizedString("All Tasks Completed! You Did It", comment: "")
            } else {
                tasksDoneLabel?.text = "\(checkedItems) \(NSLocalizedString("of", comment:"")) \(tasksCount) \(NSLocalizedString("completed", comment:""))"

            }
        }
        
        cell.configureIncomingGoal(incomingGoal: goal)
        
    }
    
    func newGoalViewController(_ controller: NewGoalViewController, didFinishEditing goal: Goal) {
        if let index = goalItems?.index(of: goal) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configure(cell as! GoalTableViewCell, with: goal)
            }
        }
 
        dismiss(animated: true, completion: nil)
    }
    
    func selectNewGoal() {
        let initialIndexPath = IndexPath(row: 0, section: 0)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition:UITableView.ScrollPosition.none)
            self.performSegue(withIdentifier: "ShowGoal", sender: initialIndexPath)
            tableView.deselectRow(at: initialIndexPath, animated: true)
        }
    }
}



extension MainGoalsViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        var goalItems = CloudKitManager.shared.goals
        let movedObject = goalItems[indexPath.row]
        goalItems.remove(at: indexPath.row)
//        goalItems.insert(movedObject, at: newIndexPath.row)
        goalItems.insert(movedObject, at: newIndexPath.row)

        
        tableView.moveRow(at: indexPath, to: newIndexPath)
        //save needs to go here.
        
//        let goalNameSortDescription = NSSortDescriptor(key: "goalName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
//        let sortedByGoalName = (goalItems as NSArray).sortedArray(using: [goalNameSortDescription])

        return true
    }
    
    
    
}



// MARK: - UIViewControllerTransitioningDelegate
extension MainGoalsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismissAnimator()
    }
}



