//
//  TaskTableViewCell.swift
//  ToDoFinalApp
//
//  Created by Jackie Norstrom on 1/9/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {


    @IBOutlet weak var taskLabel: UILabel!
    

    
    func configureTask (incomingGoal: Task) {
        taskLabel.text = incomingGoal.taskName
    }
    
    
    

}


/*
 
 Louie Example delete stuff from cloud.
 //delete both entry and data set, delete row on table, and on cloudkit.
 
 
 class func deleteRecordsFromCloud( list : [CKRecord], completion: @escaping (Bool) -> Void ) {
 
 if list.count == 0 {
 DispatchQueue.main.async {
 completion(true)
 }
 return;
 }
 
 DispatchQueue.global(qos: .background).async {
 
 let count = min(400, list.count)
 
 var newList = list
 var records : [CKRecordID] = []
 
 for _ in 0..<count {
 let object = newList[0]
 let objectId = object.recordID
 records.append(objectId)
 newList.remove(at: 0)
 }
 
 let deleteRecords = CKModifyRecordsOperation.init(recordsToSave: nil, recordIDsToDelete: records)
 deleteRecords.modifyRecordsCompletionBlock = ({(savedRecords, deletedRecords, operationError) -> Void in
 if let error = operationError {
 print("deleteRecordsFromCloud, deleteRecords error:",error)
 } else {
 Cloud.deleteRecordsFromCloud(list: newList, completion: completion)
 }
 })
 
 privateDb.add(deleteRecords)
 }
 }
 
 class func deleteItemFromCloud( _ item: NSManagedObject ) {
 
 let recordId = Cloud.recordIdForItem(item)
 
 privateDb.fetch(withRecordID: recordId) { record, error in
 if let record = record {
 Cloud.deleteRecordsFromCloud(list: [record] ) { completion in
 print("Deleted item from Cloud", item.description)
 }
 } else {
 print("Item not found on Cloud", item.description)
 }
 }
 }
 
 
 
 
 */
 

