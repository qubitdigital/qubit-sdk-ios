//
//  QBDatabase.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

class QBDatabase {

    var managedObjectContext: NSManagedObjectContext
    
    init?(modelName: String) {
        let bundle = Bundle(for: QBDatabase.self)
        guard let modelUrl = bundle.url(forResource: modelName, withExtension: "momd") else {
            QBLog.error("FatalError loading model \(modelName) from bundle")
            return nil
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            QBLog.error("FatalError loading model \(modelName) from bundle")
            return nil
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            QBLog.error("FatalError: Unable to resolve document directory")
            return nil
        }
        
        let databaseName = modelName + ".sqlite"
        let persistentStoreUrl = documentsUrl.appendingPathComponent(databaseName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl, options: nil)
        } catch {
            QBLog.error("FatalError adding persistent store: \(error)")
            return nil
        }
    }
    
}
