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

struct CloudKitManager {
    
    static var shared = CloudKitManager()
//    var smStore: SMStore!

    // this is how you can get the goals manually
    func getAllGoals(completion: @escaping (_ goals: [Goal]?)->()) {

        let query = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
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
            
            let goals = records?.map({ Goal(record: $0) })
            completion(goals)
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
            
            let goal = savedRecords?.map({ Goal(record: $0) }).first
            completion(goal)
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func editGoal(with oldName: String, newName: String, iconName: String) -> Goal? {
//        let goalsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
//        goalsFetch.predicate = NSPredicate(format: "goalName = %@", oldName)
//        do {
//            let goals = try managedContext.fetch(goalsFetch) as! [Goal]
//            let foundGoal = goals[0]
//            foundGoal.setValue(newName, forKey: "goalName")
//            return foundGoal
//        } catch {
//            print("Failed to fetch goals: \(error)")
            return nil
//        }
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
            completion(task)
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func getAllTasks(for goal: Goal, completion: @escaping (_ tasks: [Task]?)->()) {
        
        let reference = CKRecord.Reference(recordID: goal.recordId, action: .deleteSelf)
        let query = CKQuery(recordType: "Task", predicate: NSPredicate(format: "goal == %@", reference))
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
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
            completion(tasks)
        }

    }
    
    //New today date from example
    
    func getAllTasksForToday() -> [Task]? {
        
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
            return nil
//        }
        
    }
    
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

}
