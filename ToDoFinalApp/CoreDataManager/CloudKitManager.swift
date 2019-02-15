//
//  CloudKitManager.swift
//  CoreDataSyncExample
//
//  Created by Frankie Cleary on 12/4/18.
//  Copyright © 2018 FbombMedia. All rights reserved.
//

import Foundation
import CloudKit
//import Seam3

class CloudKitManager {
    
    static var shared = CloudKitManager()
//    var smStore: SMStore!
    
    
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
            
            /*
            records?.forEach { record in

                // System Field from property
                let recordName = record.recordID.recordName
                print("System Field, recordName: \(recordName)")

                // Custom Field from key path (eg: name)
                let name = record.value(forKey: "name")
                print("Custom Field, name: \(name ?? "")")
            }
            */
            
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
            }        }
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
//        let tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
//
//        let allPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: [createDatePredicate(), createNonCompletionPredicate()])
//
//        tasksFetch.predicate = allPredicates
//        do {
//            let tasks = try managedContext.fetch(tasksFetch) as! [Task]
//            return tasks
//        } catch {
//            print("Failed to fetch tasks: \(error)")
         //   return nil
//        }
        
    }
    
    /*
    private func createDatePredicate() -> NSCompoundPredicate {
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "dueDate >= %@", dateFrom as NSDate)
        
        //         let beforeTomorrow = NSPredicate (format: "dueDate < %@", NSDate(timeInterval: 60 * 60 * 24, since: Date()) )
        let toPredicate = NSPredicate(format: "dueDate < %@", dateTo! as NSDate)
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
    }
    
    func createNonCompletionPredicate() -> NSPredicate {
        return NSPredicate(format: "completed == 0")
    }
*/
}
