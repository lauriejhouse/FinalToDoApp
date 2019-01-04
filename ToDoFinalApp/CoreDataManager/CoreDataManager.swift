//
//  CoreDataManager.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/13/18.
//  Copyright © 2018 LAS. All rights reserved.
//

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
    
    func addGoal(with name: String) -> Goal? {
        //Need to add persistant container instead? Or in addition to
        let entity = NSEntityDescription.entity(forEntityName: "Goal", in: managedContext)!
        let goal = NSManagedObject(entity: entity, insertInto: managedContext) as! Goal
        
        //or goal.name = name
        goal.setValue(name, forKeyPath: "goalName")
        
        return self.save() ? goal : nil
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
}
