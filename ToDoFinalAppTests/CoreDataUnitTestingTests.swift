//
//  CoreDataUnitTestingTests.swift
//  ToDoFinalAppTests
//
//  Created by Jackie Norstrom on 2/8/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import XCTest
import  Seam3
import  CoreData
@testable import CoreDataUnitTestingTests


class CoreDataUnitTestingTests: XCTestCase {
    
    var customStorageManager: StorageManager?
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    // The customStorageManager specifies in-memory by providing a custom NSPersistentContainer
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            .
            .
            .
        }
        return container
    }()


    override func setUp() {
        super.setUp()
        customStorageManager = StorageManager(container: mockPersistantContainer)
    }
    
    func testCheckEmpty() {
        if let mgr = self.customStorageManager {
            let rows = mgr.fetchAll()
            XCTAssertEqual(rows.count, 0)
        } else {
            XCTFail()
        }
    }
}

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
