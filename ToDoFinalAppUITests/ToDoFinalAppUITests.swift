//
//  ToDoFinalAppUITests.swift
//  ToDoFinalAppUITests
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//

import XCTest
import os.log


//struct TabBarTitle {
//    static let Location = "Location"
//    static let Time = "Time"
//    static let Archived = "Archived"
//}
//
//struct Alert {
//    struct Title {
//        static let iTunesSignIn = "Sign In to iTunes Store"
//        static let chooseLocation = "Choose Location"
//        static let tenLocationsFound = "10 locations found"
//        static let pleaseUpgrade = "Please Upgrade"
//    }
//    struct Button {
//        static let OK = "OK"
//        static let Later = "Later"
//        static let Upgrade = "Upgrade"
//        static let Dismiss = "Dismiss"
//        static let Cancel = "Cancel"
//
//    }
//}


class ToDoFinalAppUITests: XCTestCase {
    let app = XCUIApplication()


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.navigationBars["Long Term Goal"].buttons["Add"].tap()
        
    }

    func testGoToTask() {
        
        let app = XCUIApplication()
        app.navigationBars["Long Term Goal"].buttons["Add"].tap()
        app.navigationBars["Add Long Term Goal"].buttons["Save"].tap()
        
        
    }
    
    func testAddingTask() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Learn Guitar")/*[[".cells.containing(.staticText, identifier:\"Select Goal To Add New Tasks.\")",".cells.containing(.staticText, identifier:\"Learn Guitar\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["More Info"].tap()
        app.navigationBars["Learn Guitar"].buttons["Add"].tap()
        app.navigationBars["Add Task"].buttons["Done"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Adding a task."]/*[[".cells.staticTexts[\"Adding a task.\"]",".staticTexts[\"Adding a task.\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
   

    }
    
    
    
    
    func testGoingToWidget() {
        
        
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.tap()
        XCUIDevice.shared.orientation = .portrait
        
        let scrollViewsQuery = app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Home screen icons\"]",".otherElements[\"SBFolderScalingView\"].scrollViews",".scrollViews"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        let contactsElement = scrollViewsQuery.otherElements.containing(.icon, identifier:"Contacts").element
        contactsElement.tap()
        XCUIDevice.shared.orientation = .portrait
        contactsElement.swipeRight()
        scrollViewsQuery.otherElements.containing(.icon, identifier:"Calendar").element.swipeRight()
        
        let elementsQuery = scrollViewsQuery.otherElements
        let wgmajorlistviewcontrollerviewScrollView = elementsQuery.scrollViews["WGMajorListViewControllerView"]
        wgmajorlistviewcontrollerviewScrollView.children(matching: .other).element.children(matching: .other).element.tap()
        wgmajorlistviewcontrollerviewScrollView.otherElements.buttons["Edit"].tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.tables.buttons["Insert MyWidget"]/*[[".otherElements[\"Home screen icons\"]",".otherElements[\"SBFolderScalingView\"].scrollViews.otherElements.tables",".cells[\"MyWidget\"].buttons[\"Insert MyWidget\"]",".buttons[\"Insert MyWidget\"]",".scrollViews.otherElements.tables"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.navigationBars["UITableView"].buttons["Done"].tap()
        
        
        
        
        
        
        
    }
    
}
