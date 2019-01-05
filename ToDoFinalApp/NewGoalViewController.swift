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

class NewGoalViewController: UITableViewController, UITextFieldDelegate
/*IconPickerViewControllerDelegate */ {
    
    // MARK: - Properties
    
    //https://github.com/paulw11/Seam3/blob/master/Sources/Classes/NSManagedObject%2BCKRecord.swift - NSManagedObject+CKRecord.swift
    
    
    var recordZone: CKRecordZone!
    
    
  //Going to need custom zone?
    
//    let recordZone = CKRecordZone.ID(zoneName: "_defaultZone", ownerName: "_6c6777e3b8e64bf08735b7eddc6cf782")
//    let ckRecordID = CKRecord.ID(recordName: recordIDString, zoneID: recordZone)
//    let ckRecord = CKRecord(recordType: myRecordType, recordID: ckRecordID)

    let container = CKContainer.default()
    var currentRecord: CKRecord?
    lazy var publicDB: CKDatabase! = {
        let DB = self.container.publicCloudDatabase
        return DB
    }()
    
    var managedContext: NSManagedObjectContext!
    
    var goalToEdit: Goal?
    
    
    let icons = ["No Icon", "Sport", "Self", "Business", "Computer", "Fun"]
    var placeholderGoals = ["Learn Programming", "Learn Piano", "Build Rome", "Become Enlightened", "Breathe Underwater", "Turn Back Time", "Run A Marathon", "Read 10 Books", "Quit Job", "Deactivate Facebook"]
    
    
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
   
    // MARK: - BPs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addGoal))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        if let goal = goalToEdit {
            title = "Edit Goal"
            goalTextField.text = goal.goalName
            doneBtn.isEnabled = true
            iconLabel.text = goal.iconName
            imageViewIcon.image = UIImage(named: goal.iconName!)
        } else {
            let randomGoals = placeholderGoals.randomItem()
            goalTextField.placeholder = "\(randomGoals!)..."
            let random = icons.randomItem()
            imageViewIcon.image = UIImage(named: random!)
            iconLabel.text = random
        }
        
        
        
    }
    
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
    
    //need to make this save to icloud when pressed
    //But done button also needs to save locally to the table and do all the things it did before.
    


        

        
    
    
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBtn.isEnabled = newText.length > 0
        
        return true
        
    }
    
    
    
    
    
    // MARK: - Icon Picker Delegate
//
//    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
//        imageViewIcon.image = UIImage(named: iconName)
//        iconLabel.text = iconName
//        navigationController?.popViewController(animated: true)
//    }
    
    
    
    
    
    
    // MARK: - Segue
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "PickIcon" {
//            let vc = segue.destination as! IconPickerViewController
//            vc.delegate = self
//        }
//    }
    
    @objc func addGoal() {
        guard let name = goalTextField.text, name != "" else
        {return
            //alert name can't be blank.
        }
        
        
        
        let _ = CoreDataManager.shared.addGoal(with: name, iconName: iconLabel.text!)
    }
    
    
    
    
}

public extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
