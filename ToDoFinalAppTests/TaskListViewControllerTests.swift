//
//  TaskListViewControllerTests.swift
//  ToDoFinalAppTests
//
//  Created by Jackie Norstrom on 2/8/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import XCTest
@testable import ToDoFinalApp

class TaskListViewControllerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let controller = TaskListViewController()
        let sum = controller.addTwoNumbers(a: 3, b: 5)
        XCTAssertEqual(8, sum)
        
    }

}
