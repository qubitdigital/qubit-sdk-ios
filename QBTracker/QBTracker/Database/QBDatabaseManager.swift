//
//  QBDatabaseManager.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

class QBDatabaseManager {
    
    static let shared = QBDatabaseManager()
    static let kQBDataModelName = "QBDataModel"
    
    var database: QBDatabase
    
    private init() {
        database = QBDatabase(modelName: QBDatabaseManager.kQBDataModelName)
    }
    
    func query<T: NSManagedObject>(entity: T, predicate: NSPredicate? = nil) -> [T] {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            let results = try database.managedObjectContext.fetch(fetchRequest) as? [T] ?? []
            return results
        } catch {
            print ("Error performing query for entityName: \(entityName) error: \(error.localizedDescription)")
        }
        
        return []
    }
    
    func insert<T: NSManagedObject>(entity: T) -> T? {
        let entityName = String(describing: entity)
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: database.managedObjectContext) as? T
        
        return object
    }
    
    func save() -> Bool {
        do {
            try database.managedObjectContext.save()
            return true
        } catch {
            print ("Error saving changes to database \(error.localizedDescription)")
        }
        
        return false
    }
    
    func deleteAll<T: NSManagedObject>(from entity: T) -> Bool {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        
        do {
            let results = try database.managedObjectContext.fetch(fetchRequest) as? [T] ?? []
            return delete(entries: results)
        } catch {
            print ("Error deleting all entries from entityName: \(entityName) error: \(error.localizedDescription)")
        }
        
        return false
    }
    
    func delete(entries: [NSManagedObject]) -> Bool {
        do {
            for entry in entries {
                database.managedObjectContext.delete(entry)
            }
            try database.managedObjectContext.save()
            return true
        } catch {
            print ("Error deleting entries: \(error.localizedDescription)")
        }
        
        return false
    }
}
