//
//  DataPersistenceService.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/28/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import CoreData

class DataPersistenceService: NSManagedObject {
    private let context = DataController.shared.persistentContainer.viewContext
//    var mainEntity = NSEntityDescription()
//    
//    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
//        super.init(entity: entity, insertInto: context)
//        let entity = NSEntityDescription.entity(forEntityName: "SearchTerms", in: self.context)
//        self.mainEntity = entity!
//    }
    
    func saveData(term: String) {
        let entity = NSEntityDescription.entity(forEntityName: "SearchTerms", in: context)
        let newRecord = NSManagedObject(entity: entity!, insertInto: context)
        
        newRecord.setValue(term, forKey: "term")

        do {
            try context.save()
        } catch {
            print("The term could not be saved!")
        }
    }
    
    func loadData() -> [String]? {
        var termsArray: [String] = [String]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchTerms")
        
        do {
            let records = try context.fetch(request) as! [NSManagedObject]
            for item in records {
                termsArray.insert("\(item.value(forKey: "term")!)", at: 0)
            }
        } catch {
            print("Data not found!")
        }
        return termsArray
    }
    
    func deleteData(term: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchTerms")
        request.predicate = NSPredicate(format: "term = %@", term)
        
        do {
            let record = try context.fetch(request) as! [NSManagedObject]
            for item in record {
                context.delete(item)
                
                do {
                    try context.save()
                } catch {
                    print("There was a problem while saving changes.")
                }
            }
        } catch {
            print("Request nos founded!")
        }
    }
}
