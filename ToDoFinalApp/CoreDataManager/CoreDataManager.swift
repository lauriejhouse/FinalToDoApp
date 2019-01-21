//
//  CoreDataManager.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/13/18.
//  Copyright © 2018 LAS. All rights reserved.
//Blarghblahblarh

import Foundation
import CoreData
import Seam3

struct CoreDataManager {
    

    
    static var shared = CoreDataManager()
    var managedContext: NSManagedObjectContext!
    var smStore: SMStore!
    
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
    
    func addTask(to goal: Goal, with name: String) -> Task? {
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext) as! Task
        task.setValue(name, forKeyPath: "taskName")
        
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
    
    func getAllTasksForToday() -> [Task]? {
        //build two predicates. predicate 1 adn 2, supply argument you're looking for within the NSFetch format,
        //Second predicate is greater then yesterday, less then tomorrow.
        //Time interval NSDate, date by adding time interval. Add in seconds.
        //Group predicate, add both and assign it to fetch predicate.
        let tasksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        tasksFetch.predicate = NSPredicate (format: "dueDate < %@", NSDate())
//        tasksFetch.predicate = NSPredicate
        do {
            let goals = try managedContext.fetch(tasksFetch) as! [Task]
            return goals
        } catch {
            print("Failed to fetch goals: \(error)")
            return nil
        }
    }

    
    
    
}
