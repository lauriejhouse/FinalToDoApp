//
//  CoreDataStack.swift
//  ToDoFinalApp
//
//  Created by Jackie Norstrom on 1/18/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import Foundation
import CoreData
import Seam3

public class CoreDataStack {
    
    
    private static var sharedInstance: CoreDataStack!

    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        SMStore.registerStoreClass()
        
        let container = NSPersistentContainer(name: "ToDoFinalApp")
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        
        //Need both of these for app groups to work correctly with core data and have everything display on the simulator. It's all showing up in CloudKit, but not simulator..
        
        //         let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.las.FinalAppToDo")
        
        
        //         if let applicationDocumentsDirectory = directory {
        
        
        
        if let applicationDocumentsDirectory = urls.last {
            
            
            
            let url = applicationDocumentsDirectory.appendingPathComponent("ToDoFinalApp.sqlite")
            
            
            
            let storeDescription = NSPersistentStoreDescription(url: url)
            
            storeDescription.type = SMStore.type
            
            container.persistentStoreDescriptions=[storeDescription]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    
                    
                    
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }
        
        
        
        fatalError("Unable to access documents directory")
        
    }()
    
    
    
    // MARK: - Core Data Saving support
    //This also has to be put into the new COreDataStakc file
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
}


