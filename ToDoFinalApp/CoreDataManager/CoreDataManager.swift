//
//  CoreDataManager.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/13/18.
//  Copyright © 2018 LAS. All rights reserved.
//Blarghblahblarh

import Foundation
import CoreData


//Something wrong with CoreData migration or model - How Seam3 interacts?

struct CoreDataManager {
    
    static var shared = CoreDataManager()
    var managedContext: NSManagedObjectContext!
    
    func save() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch {
            print("Could not save. \(error.localizedDescription)")
            return false
        }
    }
    
    func addGoal(with name: String, iconName: String) -> Goal? {
        //Need to add persistant container instead? Or in addition to
        let entity = NSEntityDescription.entity(forEntityName: "Goal", in: managedContext)!
        let goal = NSManagedObject(entity: entity, insertInto: managedContext) as! Goal
        
        //or goal.name = name
        goal.setValue(name, forKeyPath: "goalName")
        goal.iconName = iconName

        return self.save() ? goal : nil
    }
    
    func editGoal(with oldName: String, newName: String, iconName: String) -> Goal? {
        let goalsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        goalsFetch.predicate = NSPredicate(format: "goalName = %@", oldName)
        do {
            let goals = try managedContext.fetch(goalsFetch) as! [Goal]
            let foundGoal = goals[0]
            foundGoal.setValue(newName, forKey: "goalName")
            return foundGoal
        } catch {
            print("Failed to fetch goals: \(error)")
            return nil
        }
    }
    
    func addTask(to goal: Goal, with name: String, dueDate: NSDate) -> Task? {
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext) as! Task
       
        task.taskName = name
        task.isChecked = false
        task.dueDate = dueDate
        
        goal.addToTasks(task)
        
        return self.save() ? task : nil
    }
    
    func getAllGoals() -> [Goal]? {
        
        let goalsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        
        do {
            let goals = try managedContext.fetch(goalsFetch) as! [Goal]
            return goals
        } catch {
            print("Failed to fetch goals: \(error)")
            return nil
        }
    }
    
    func getAllTasks() -> [Task]? {
        
        let tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let goals = try managedContext.fetch(tasksFetch) as! [Task]
            return goals
        } catch {
            print("Failed to fetch goals: \(error)")
            return nil
        }
    }
    
    //New today date from example
    
    func getAllTasksForToday() -> [Task]? {
        
        let tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        let allPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: [createDatePredicate(), createNonCompletionPredicate()])
        
                tasksFetch.predicate = allPredicates
                do {
                    let tasks = try managedContext.fetch(tasksFetch) as! [Task]
                    return tasks
                } catch {
                    print("Failed to fetch tasks: \(error)")
                    return nil
                }
        
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
