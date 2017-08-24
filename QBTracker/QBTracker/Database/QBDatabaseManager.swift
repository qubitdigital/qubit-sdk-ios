//
//  QBDatabaseManager.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

public class QBDatabaseManager {
    
    public static let shared = QBDatabaseManager()
    static let kQBDataModelName = "QBDataModel"
    
    var database: QBDatabase?
    
    private init() {
        database = QBDatabase(modelName: QBDatabaseManager.kQBDataModelName)
    }
    
    public func query<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate? = nil) -> [T] {
        guard let database = database else {
            print("Database is not initialized")
            return []
        }
        
        let entityName = String(describing: entityType)
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
    
    public func insert<T: NSManagedObject>(entityType: T.Type) -> T? {
        guard let database = database else {
            print("Database is not initialized")
            return nil
        }
        
        let entityName = String(describing: entityType)
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: database.managedObjectContext) as? T
        
        return object
    }
    
    @discardableResult public func save() -> Bool {
        guard let database = database else {
            print("Database is not initialized")
            return false
        }
        
        do {
            try database.managedObjectContext.save()
            return true
        } catch {
            print ("Error saving changes to database \(error.localizedDescription)")
        }
        
        return false
    }
    
    @discardableResult public func deleteAll<T: NSManagedObject>(from entityType: T.Type) -> Bool {
        guard let database = database else {
            print("Database is not initialized")
            return false
        }
        
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
        
        do {
            let results = try database.managedObjectContext.fetch(fetchRequest) as? [T] ?? []
            return delete(entries: results)
        } catch {
            print ("Error deleting all entries from entityName: \(entityName) error: \(error.localizedDescription)")
        }
        
        return false
    }
    
    @discardableResult func delete(entries: [NSManagedObject]) -> Bool {
        guard let database = database else {
            print("Database is not initialized")
            return false
        }
        
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
