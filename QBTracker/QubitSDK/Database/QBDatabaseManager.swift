//
//  QBDatabaseManager.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

class QBDatabaseManager {
    static let kQBDataModelName = "QBDataModel"
    
    var database: QBDatabase?
    
    init() {
        database = QBDatabase(modelName: QBDatabaseManager.kQBDataModelName)
    }
    
    func query<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate? = nil, sortBy: String? = nil, ascending: Bool = false, limit: Int = 0, completion:( ([T]) -> Void )?) {
        guard let database = database else {
            QBLog.error("Database is not initialized")
            completion?([])
            return
        }
        
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let sortBy = sortBy, !sortBy.isEmpty {
            let sortDescriptor = NSSortDescriptor(key: sortBy, ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit
        
        database.managedObjectContext.performAndWait {
            do {
                let results = try database.managedObjectContext.fetch(fetchRequest) as? [T] ?? []
                completion?(results)
            } catch {
                completion?([])
                QBLog.error("Error performing query for entityName: \(entityName) error: \(error.localizedDescription)")
            }
        }
    }
    
    func insert<T: NSManagedObject>(entityType: T.Type) -> T? {
        guard let database = database else {
            QBLog.error("Database is not initialized")
            return nil
        }
        
        let entityName = String(describing: entityType)
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: database.managedObjectContext) as? T
        
        return object
    }
    
    func save() {
        guard let database = database else {
            QBLog.error("Database is not initialized")
            return
        }
        
        database.managedObjectContext.performAndWait {
            do {
                try database.managedObjectContext.save()
            } catch {
                QBLog.error("Error saving changes to database \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAll<T: NSManagedObject>(from entityType: T.Type) {
        guard let database = database else {
            QBLog.error("Database is not initialized")
            return
        }
        
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
        
        database.managedObjectContext.performAndWait {
            do {
                let results = try database.managedObjectContext.fetch(fetchRequest) as? [T] ?? []
                delete(entries: results)
            } catch {
                QBLog.error("Error deleting all entries from entityName: \(entityName) error: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(entries: [NSManagedObject]) {
        guard let database = database else {
            QBLog.error("Database is not initialized")
            return
        }
        
        database.managedObjectContext.performAndWait {
            do {
                for entry in entries {
                    database.managedObjectContext.delete(entry)
                }
                try database.managedObjectContext.save()
            } catch {
                QBLog.error("Error deleting entries: \(error.localizedDescription)")
            }
        }
    }
}
