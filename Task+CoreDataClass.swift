//
//  Task+CoreDataClass.swift
//  ToDoFinalApp
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 LAS. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    
    func toggleChecked() {
        isChecked = !isChecked
    }


}
