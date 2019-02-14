//
//  Goal.swift
//  ToDoFinalApp
//
//  Created by Frankie Cleary on 2/14/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import Foundation
import CloudKit

class Goal: NSObject {
    
    var goalName: String
    var iconName: String?
    var tasks: [CKRecord.Reference]?
    var recordId: CKRecord.ID
    
    init(record: CKRecord) {
        self.goalName = record.value(forKey: "goalName") as! String
        self.recordId = record.recordID
        self.tasks = record.value(forKey: "tasks") as? [CKRecord.Reference]
    }
}


