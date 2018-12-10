//
//  Task+CoreDataProperties.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var goal: Goal?

}
