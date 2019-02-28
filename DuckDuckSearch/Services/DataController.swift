//
//  DataController.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/28/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    var persistentContainer: NSPersistentContainer
    
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "DuckDuckSearch")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
}
