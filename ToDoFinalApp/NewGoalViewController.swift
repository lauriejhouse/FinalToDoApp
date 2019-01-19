//
//  NewGoalViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CloudKit
import Seam3






class NewGoalViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    // MARK: - Properties



    let container = CKContainer.default()
    var currentRecord: CKRecord?
    lazy var publicDB: CKDatabase! = {
        let DB = self.container.publicCloudDatabase
        return DB
    }()
    
    var managedContext: NSManagedObjectContext!
    
    

    var goalToEdit: Goal?
    var goals = [Goal]()
    var oldGoalName: String? = ""
    var inEditMode = false
    
    
    let icons = ["No Icon", "Sports", "Self", "Business", "Computers", "Fun"]
    var placeholderGoals = ["Learn Programming", "Learn Guitar", "Build an Empire", "Become Enlightened", "Breathe Underwater", "Turn Back Time", "Run A Marathon", "Read 100 Books", "Quit Job", "Deactivate Facebook"]
    
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    
   // MARK: - BPs
    
    
    //Modified to try and incoperate original and CoreData eXample.
        override func viewDidLoad() {
            super.viewDidLoad()
    
            let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addGoal))
            self.navigationItem.rightBarButtonItem = rightBarButton
    
    
            //Allows edit button to be clicked on and current cell be edited. But when save is clicked it adds a new cell. Need to add an if else statement to add goal?
            if let goal = goalToEdit {
                title = "Edit Goal"
                inEditMode = true
                goalTextField.text = goal.goalName
                oldGoalName = goal.goalName
    //            doneBtn.isEnabled = true
            
                iconLabel.text = goal.iconName
                imageViewIcon.image = UIImage(named: goal.iconName ?? "No Icon")
            } else {
                let randomGoals = placeholderGoals.randomItem()
                goalTextField.placeholder = "\(randomGoals!)..."
                let random = icons.randomItem()
                imageViewIcon.image = UIImage(named: random!)
                iconLabel.text = random
            }
    
            
            CloudKitManager.shared.triggerSyncWithCloudKit()
            
                    NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: SMStoreNotification.SyncDidFinish), object: nil, queue: nil) { notification in
            
                        if notification.userInfo != nil {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.smStore?.triggerSync(complete: true)
                        }
            //commenting out to get rid of the error.
//                        self.managedContext.refreshAllObjects()
//
                        DispatchQueue.main.async {
                            self.goals = CoreDataManager.shared.getAllGoals() ?? []
                            self.tableView.reloadData()
                        }
                    }
    
    
        }
    
    
    
    
    //Copied from CoreDataExample App.
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGoal))
//        self.navigationItem.rightBarButtonItem = rightBarButton
//
//        CloudKitManager.shared.triggerSyncWithCloudKit()
//
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: SMStoreNotification.SyncDidFinish), object: nil, queue: nil) { notification in
//
//            if notification.userInfo != nil {
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.smStore?.triggerSync(complete: true)
//            }
//
////            self.managedContext.refreshAllObjects()
////
////            DispatchQueue.main.async {
////                self.goals = CoreDataManager.shared.getAllGoals() ?? []
////                self.tableView.reloadData()
////            }
//        }
//    }

    
    
    
   //Original I was working with
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addGoal))
//        self.navigationItem.rightBarButtonItem = rightBarButton
//
//
//        if let goal = goalToEdit {
//            title = "Edit Goal"
//            goalTextField.text = goal.goalName
////            doneBtn.isEnabled = true
//            iconLabel.text = goal.iconName
//            imageViewIcon.image = UIImage(named: goal.iconName ?? "No Icon")
//        } else {
//            let randomGoals = placeholderGoals.randomItem()
//            goalTextField.placeholder = "\(randomGoals!)..."
//            let random = icons.randomItem()
//            imageViewIcon.image = UIImage(named: random!)
//            iconLabel.text = random
//        }
//
//
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goalTextField.becomeFirstResponder()
    }
    
    func notifyUser(_ title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    
    
    // MARK: - Action Methods
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
//    @IBAction func done(_ sender: Any) {
//
//        //used to try and get edit button in cell to work correctly.
//        if let goal = goalToEdit {
//            title = "Edit Goal"
//            goalTextField.text = goal.goalName
////            doneBtn.isEnabled = true
//            iconLabel.text = goal.iconName
//            imageViewIcon.image = UIImage(named: goal.iconName ?? "No Icon")
//        } else {
//            let randomGoals = placeholderGoals.randomItem()
//            goalTextField.placeholder = "\(randomGoals!)..."
//            let random = icons.randomItem()
//            imageViewIcon.image = UIImage(named: random!)
//            iconLabel.text = random
//        }
//
//
//
//        self.dismiss(animated: true, completion: nil)
//    }
    

 
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 2 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    
    
    
    // MARK: - Text Field Delegate
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let oldText = textField.text! as NSString
//        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
//
////        doneBtn.isEnabled = newText.length > 0
//
//        return true
//
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let name = textField.text {
            self.goalToEdit?.goalName = name
            let _ = CoreDataManager.shared.save()
        }
        
        return true
    }
    
   
    
    // MARK: - Icon Picker Delegate
//
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        imageViewIcon.image = UIImage(named: iconName)
        iconLabel.text = iconName
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    // MARK: - Segue
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let vc = segue.destination as! IconPickerViewController
            vc.delegate = self
        }
    }
    
    @objc func addGoal() {
        guard let name = goalTextField.text, name != "" else
        {return
            //alert name can't be blank.
        }
        
        
        if inEditMode {
            let _ = CoreDataManager.shared.editGoal(with: oldGoalName!, newName: name, iconName: iconLabel.text ?? "No Icon")
            let _ = CoreDataManager.shared.save()
        } else {
            let _ = CoreDataManager.shared.addGoal(with: name, iconName: iconLabel.text ?? "No Icon")
            let _ = CoreDataManager.shared.save()
        }

        dismiss(animated: true, completion: nil)
        ///added save to try and save editws.
    }
    
}

public extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
