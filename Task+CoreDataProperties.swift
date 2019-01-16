//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Jackie Norstrom on 1/16/19.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var isChecked: Bool
    @NSManaged public var goal: Goal?

}
