//
//  CoreDataStack.swift
//  Tasks
//
//  Created by alfredo on 2/14/20.
//  Copyright © 2020 Alfredo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    //Persistent Store Coordinator
    lazy var container: NSPersistentContainer = {
        //name: has to be extact name of XCDataModel Directory
        let newContainer = NSPersistentContainer(name: "Tasks")
        newContainer.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError("Failed to load persistent stores: \(error!)") }
            
            
        }
        return newContainer
    }()
    
    //Managed Object Context
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
