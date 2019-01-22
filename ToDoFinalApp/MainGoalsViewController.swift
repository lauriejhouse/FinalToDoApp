//
//  ViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//



//Things left to do:
/*
 
 WAIT FOR FRANKIE FOR HELP WITH WIDGET.

 Today Widget - Most difficult
 Custom animations 2-4 of them
 Testing/Debugging -easy
 Analytics to track tasks
 Monetization - adds on app through google. - pretty easy
 Document and press kit. - easy
 

 
 
 
 */

import UIKit
import Foundation
import CoreData
import TableViewDragger
import CloudKit



class MainGoalsViewController: UITableViewController {
    
//For TableViewDragger CocoaPod
    var dragger: TableViewDragger!


    //For CloudKit
//    let container = CKContainer.default()
//    let record = CKRecord(recordType: "Goal")
//    lazy var publicDB: CKDatabase! = {
//        let DB = self.container.publicCloudDatabase
//        return DB
//    }()

    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 75
    lazy var managedContext = {
       return CoreDataManager.shared.managedContext!
        
    }()
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
        fetch()
        selectNewGoal()
        dragger = TableViewDragger(tableView: tableView)
        dragger.dataSource = self
        dragger.delegate = self
        dragger.alphaForCell = 0.7
        dragger.opacityForShadowOfCell = 1
//Can add a date label here
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goalItems = CoreDataManager.shared.getAllGoals()
        //what comes out of the right side is put into the left.
        //shared instance. any class changes properties those propties will be reflected eveyrwhere if you have one instance.
        tableView.reloadData()

    }
    
    //For Date Picker. Or just set that all tasks are due today or the next day.
    func formattedReleaseDate() -> String {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 25
        components.month = 9
        components.year = 2019
        let date = calendar.date(from: components)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date!)
    }
    
    
    
    
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let goalItems = goalItems {
            return goalItems.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath  ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalTableViewCell
        if let goalItems = goalItems {
            let goalItem = goalItems[indexPath.row]
            configure(cell, with: goalItem)
        }
        
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
                
                guard let goalToDelete = self.goalItems?[indexPath.row] else { return }
                self.goalItems?.remove(at: indexPath.row)
                self.managedContext.delete(goalToDelete)
                self.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.selectNewGoal()
                
            }
            
            deleteAlertController.addAction(cancelAction)
            deleteAlertController.addAction(deleteAction)
            present(deleteAlertController, animated: true, completion: nil)
            
        }
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
//            goalVC.managedContext = managedContext
            
        } else if segue.identifier == "EditGoal" {
            let nav = segue.destination as! UINavigationController
            let goalVC = nav.topViewController as! NewGoalViewController
            
            if let button = sender as? UIButton {
                goalVC.goalToEdit = goalItems?[button.tag]
            }
        } else if segue.identifier == "ShowGoal" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let nav = segue.destination as! UINavigationController
                let vc = nav.topViewController as! TaskViewController
                if let goalItems = goalItems {
                    if !goalItems.isEmpty {
                        let item = goalItems[indexPath.row]
                        vc.selectedGoal = item
                        vc.title = item.goalName
                    } else {
                        // If the goalItems array has nothing in it, then we show this below
                        vc.title = NSLocalizedString("Your Tasks Will Appear Here.", comment: "")
                        vc.navigationItem.rightBarButtonItem?.isEnabled = false
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Custom Methods
    //Way to do this without using tags. Tags were before storyboads.
    func configure(_ cell: GoalTableViewCell, with goal: Goal) {
//        let icon = cell.viewWithTag(10) as? UIImageView
        let tasksDoneLabel = cell.taskCountLabel
        guard let tasksCount = goal.tasks?.count else { return }
        //call tasksdonelabel from the goal view cell
        
        
        fetchCheckedItems(with: goal)
        
        if let checkedItems = checkedItems {
            if tasksCount == 0 {
                tasksDoneLabel?.text = NSLocalizedString("Select Goal To Add New Tasks", comment: "")
            } else if checkedItems == 0 {
                tasksDoneLabel?.text = "\(tasksCount) \(NSLocalizedString("to complete", comment:""))"
            } else if checkedItems == tasksCount {
                tasksDoneLabel?.text = NSLocalizedString("All Tasks Completed", comment: "")
            } else {
                tasksDoneLabel?.text = "\(checkedItems) \(NSLocalizedString("of", comment:"")) \(tasksCount) \(NSLocalizedString("completed", comment:""))"

            }
        }
        
        cell.configure(incomingGoal: goal)
        
    }
    
    
    //Do I need these here if everything is being managed in CoreDataManager?
    func save() {
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print(error)
        }
    }

    
    
    //Do i need these here if everything is being managed in CoreDataManager?
    func fetch() {
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            let results = try managedContext.fetch(request)
            goalItems?.append(contentsOf: results)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func fetchCheckedItems(with goal: Goal) {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.predicate = NSPredicate(format: "goal == %@ AND enabled == %@ ", goal, NSNumber(booleanLiteral: true))
        
        do {
            let results = try managedContext.fetch(request)
            checkedItems = results.count
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func newGoalViewController(_ controller: NewGoalViewController, didFinishEditing goal: Goal) {
        if let index = goalItems?.index(of: goal) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configure(cell as! GoalTableViewCell, with: goal)
            }
        }
        save()
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
        let movedObject = self.goalItems?[indexPath.row]
        goalItems?.remove(at: indexPath.row)
        goalItems?.insert(movedObject!, at: newIndexPath.row)
        
        tableView.moveRow(at: indexPath, to: newIndexPath)
        
        return true
    }
}
