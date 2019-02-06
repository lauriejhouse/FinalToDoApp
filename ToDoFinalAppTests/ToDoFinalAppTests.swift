//
//  ToDoFinalAppTests.swift
//  ToDoFinalAppTests
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import XCTest
@testable import ToDoFinalApp

class ToDoFinalAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testCreateGoal(goalName: String, iconName: String, moc: NSManagedObjectContext) {
        let goal =  Goal(context: moc)
        goal.goalName = goalName
        goal.iconName = iconName
        do {
            try moc.save()
        } catch let error as NSError {
            os_log("Error try to create one sample task: %@", log: .default, type: .default, error.debugDescription)
        }
        
        
    }
    
    /*
 struct CoreDataTestUtil {
 
 static func createOneTask(identifier: String, title: String, moc: NSManagedObjectContext) {
 let task = Task(context: moc)
 task.setDefaultsForLocalCreate()
 task.identifier = identifier
 task.title = title
 do {
 try moc.save()
 } catch let error as NSError {
 os_log("Error try to create one sample task: %@", log: .default, type: .default, error.debugDescription)
 }
 }
 
 */
 
 
 
    
    

}
