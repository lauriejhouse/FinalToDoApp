//
//  CoreDataStack.swift
//  ToDoFinalApp
//
//  Created by Jackie Norstrom on 1/16/19.
//  Copyright © 2019 LAS. All rights reserved.
//



import Foundation
import CoreData

public class CoreDataStack {
    
    private let modelName: String
    
    private static var sharedInstance: CoreDataStack!
    
    private init(modelName: String) {
        self.modelName = modelName
        CoreDataStack.sharedInstance = self
    }
    
    // Note: model name can't be change, only the first time initialize the model, other times will be ignored.
    public static func shared(modelName: String) -> CoreDataStack {
        switch (sharedInstance, modelName) {
        case let (nil, modelName):
            sharedInstance = CoreDataStack(modelName: modelName)
            return sharedInstance
        default:
            return sharedInstance
        }
    }
    
    public lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        
        let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "com.las.ToDoFinalApp")
        
        if let applicationDocumentsDirectory = directory {
            let url = applicationDocumentsDirectory.appendingPathComponent("ToDoFinalApp.sqlite")
            let storeDescription = NSPersistentStoreDescription(url: url)
            
            container.persistentStoreDescriptions = [storeDescription]
            
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            print("Location for the sqlite3 file: ")
            print(url)
            
            return container
        }
        fatalError("Unable to access group documents directory")
    }()
    
    public lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}


