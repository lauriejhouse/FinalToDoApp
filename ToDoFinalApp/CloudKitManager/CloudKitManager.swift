//
//  CloudKitManager.swift
//  CoreDataSyncExample
//
//  Created by Frankie Cleary on 12/4/18.
//  Copyright © 2018 FbombMedia. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    static var shared = CloudKitManager()
    
    
    var container : CKContainer {
        return CKContainer.init(identifier:"iCloud.com.las.ToDoFinalApp")
    }

    var publicDb : CKDatabase {
        return container.publicCloudDatabase
    }
    
    var goals = [Goal]()

    // this is how you can get the goals manually
    func getAllGoals(completion: @escaping (_ goals: [Goal]?)->()) {

        let query = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
        publicDb.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
 
            if let records = records {
                /*let */self.goals = records.map{ Goal(record: $0) }
                DispatchQueue.main.async {
                    completion(self.goals)
                }
            } else {
                self.goals = []
            }
            
            self.goals.forEach { goal in
                self.getAllTasks(for: goal) { tasks in
                    if let tasks = tasks {
                        goal.tasks = tasks
                        completion(self.goals)
                    } else {
                        goal.tasks = [Task]()
                    }
                }
            }
            
        }
    }
    
    
    
    func addGoal(with name: String, iconName: String, completion: @escaping (_ goal: Goal?)->()) {
        
        let goal = CKRecord(recordType: "Goal")
        goal.setObject(name as NSString, forKey: "goalName")
        
        let operation = CKModifyRecordsOperation(recordsToSave: [goal], recordIDsToDelete: nil)
        
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
            if let goal = savedRecords?.map({ Goal(record: $0) }).first {
                DispatchQueue.main.async {
                completion(goal)
                }
                self.goals.append(goal)
            }
        }
        
        publicDb.add(operation)
    }
    
    
    
    func editGoal(with goal: Goal) {
        publicDb.fetch(withRecordID: goal.recordId) { record, error in
            if let record = record {
                record.setValue(goal.goalName, forKey: "goalName")
                record.setValue(goal.iconName, forKey: "iconName")
                
                let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
                
                operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                    if let error = error {
                        print("There was an error: \(error.localizedDescription)")
                        return
                    }
                }
                
                self.publicDb.add(operation)
                
            } else {
                print("Goal not found on Cloud", goal.goalName)
            }
            
        }
    }
    
    
    
    func addTask(to goal: Goal, with name: String, dueDate: NSDate, completion: @escaping (_ task: Task?)->()) {
        
        let task = CKRecord(recordType: "Task")
        task.setObject(name as NSString, forKey: "taskName")
        
        let reference = CKRecord.Reference(recordID: goal.recordId, action: .deleteSelf)
        task["goal"] = reference
        
        let operation = CKModifyRecordsOperation(recordsToSave: [task], recordIDsToDelete: nil)
        
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
            let task = savedRecords?.map({ Task(record: $0) }).first
            DispatchQueue.main.async {
                if let task = task {
                goal.tasks.append(task)
                }
                completion(task)
            }
        }
        
        publicDb.add(operation)
    }
    
    
    
    
    func editTask ( task : Task ) {
        publicDb.fetch(withRecordID: task.recordId) { record, error in
            if let record = record {
                record.setValue(task.taskName, forKey: "taskName")
                record.setValue(task.completed, forKey: "completed")
                record.setValue(task.dueDate, forKey: "dueDate")
                
                let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
                //to delete record, make records to save nil, pass through record in recordstodelete
                
                operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                    if let error = error {
                        print("There was an error: \(error.localizedDescription)")
                        return
                    }
                }
                
                self.publicDb.add(operation)
                

            } else {
                print("Task not found on Cloud", task.taskName)
            }
        }
    }
    
    
    
    func getAllTasks(for goal: Goal, completion: @escaping (_ tasks: [Task]?)->()) {
        
        let reference = CKRecord.Reference(recordID: goal.recordId, action: .deleteSelf)
        let query = CKQuery(recordType: "Task", predicate: NSPredicate(format: "goal == %@", reference))
        publicDb.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }
            
            records?.forEach({ (record) in
                
                // System Field from property
                let recordName = record.recordID.recordName
                print("System Field, recordName: \(recordName)")
                
                // Custom Field from key path (eg: name)
                let name = record.value(forKey: "name")
                print("Custom Field, name: \(name ?? "")")
            })
            
            let tasks = records?.map({ Task(record: $0) })
            DispatchQueue.main.async {
                completion(tasks)
            }
        }

    }
    
    
    func deleteGoal(with goal: Goal, completion: @escaping ()->()) {
        
        publicDb.delete(withRecordID: goal.recordId, completionHandler: { recordId, error in
            
            if let error = error {
                print("There was a deleteGoal error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                completion()
            }
        })
    }

    
   //From louis example
//
//     func deleteRecordsFromCloud( list : [CKRecord], completion: @escaping (Bool) -> Void ) {
//
//        if list.count == 0 {
//            DispatchQueue.main.async {
//                completion(true)
//            }
//            return;
//        }
//
//        DispatchQueue.global(qos: .background).async {
//
//            let count = min(400, list.count)
//
//            var newList = list
//            var records : [CKRecord.ID] = []
//
//            for _ in 0..<count {
//                let object = newList[0]
//                let objectId = object.recordID
//                records.append(objectId)
//                newList.remove(at: 0)
//            }
//
//            let deleteRecords = CKModifyRecordsOperation.init(recordsToSave: nil, recordIDsToDelete: records)
//            deleteRecords.modifyRecordsCompletionBlock = ({(savedRecords, deletedRecords, operationError) -> Void in
//                if let error = operationError {
//                    print("deleteRecordsFromCloud, deleteRecords error:",error)
//                } else {
//                    publ.deleteRecordsFromCloud(list: newList, completion: completion)
//                }
//            })
//
//            self.publicDb.add(deleteRecords)
//        }
//    }
    
 
    
    
//     func deleteItemFromCloud( _ item: NSManagedObject ) {
//        
//        let recordId = Cloud.recordIdForItem(item)
//        
//        privateDb.fetch(withRecordID: recordId) { record, error in
//            if let record = record {
//                Cloud.deleteRecordsFromCloud(list: [record] ) { completion in
//                    print("Deleted item from Cloud", item.description)
//                }
//            } else {
//                print("Item not found on Cloud", item.description)
//            }
//        }
//    }
    
    
    
    func getAllTasksForToday( completion : @escaping (([Task]) -> Void) ) {
        getAllGoals() { goals in
            var tasks = [Task]()
            goals?.forEach {
                tasks.append(contentsOf: $0.tasks.compactMap { task in
                    return task.widgetTask ? task : nil                    
                } )
            }
            completion(tasks)
        }

        
    }
    
    
    
//    func deleteGoal(with goal: Goal, completion: @escaping ()->()) {
//        
//        publicDb.delete(withRecordID: goal.recordId, completionHandler: { recordId, error in
//            
//            if let error = error {
//                print("There was a deleteGoal error: \(error.localizedDescription)")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion()
//            }
//        })
//    }
    
    

}



/* Louie Example delete stuff from cloud.
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
 
 
