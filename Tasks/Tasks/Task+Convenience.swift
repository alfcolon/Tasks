//
//  Task+Convenience.swift
//  Tasks
//
//  Created by alfredo on 2/14/20.
//  Copyright © 2020 Alfredo. All rights reserved.
//

import CoreData

enum TaskPriority: String {
    case low
    case normal
    case high
    case critical
    
    static var allPriorites: [TaskPriority] {
        return [.low, .normal, .high, .critical]
    }
}
extension Task {
    convenience init(name: String,
                     notes: String? = nil,
                     priority: TaskPriority = .normal,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
    }
}
