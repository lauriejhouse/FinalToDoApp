//
//  Task.swift
//  ToDoFinalApp
//
//  Created by Frankie Cleary on 2/14/19.
//  Copyright © 2019 LAS. All rights reserved.
//

import Foundation
import CloudKit


extension Date {
    var isToday : Bool {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? Date.distantPast
        
        return self >= dateFrom && self <= dateTo
    }
}

class Task: NSObject {

    var completed: Bool = false
    var taskName: String
    var dueDate: NSDate?
    var isChecked: Bool = false
    var enabled: Bool = false
    var goal: CKRecord.Reference?
    var recordId: CKRecord.ID
    
    var widgetTask : Bool {
        if let dueDate = dueDate {
            return completed == false && (dueDate as Date).isToday
        }
        return completed == false
    }

    init(record: CKRecord) {
        self.taskName = record.value(forKey: "taskName") as? String ?? ""
        self.dueDate = record.value(forKey: "dueDate") as? NSDate
        self.completed = record.value(forKey: "completed") as? Bool ?? false
        self.recordId = record.recordID
        self.goal = record.value(forKey: "goal") as? CKRecord.Reference
    }
    
}


