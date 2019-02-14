//
//  Task.swift
//  ToDoFinalApp
//
//  Created by Frankie Cleary on 2/14/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import Foundation
import CloudKit

class Task: NSObject {

    var completed: Bool = false
    var taskName: String
    var dueDate: NSDate?
    var isChecked: Bool = false
    var enabled: Bool = false
    var goal: CKRecord.Reference?
    var recordId: CKRecord.ID

    init(record: CKRecord) {
        self.taskName = record.value(forKey: "taskName") as! String
        self.recordId = record.recordID
        self.goal = record.value(forKey: "goal") as? CKRecord.Reference
    }
}


