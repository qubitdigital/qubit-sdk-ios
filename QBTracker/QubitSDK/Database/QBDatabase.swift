//
//  QBDatabase.swift
//  QubitSDK
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
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]

        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            QBLog.error("FatalError: Unable to resolve document directory")
            return nil
        }
        
        #if targetEnvironment(simulator)
        // Documents folder missing on simulator from iOS 11
        // See -> https://stackoverflow.com/questions/50133212/ios-document-folder-is-not-a-directory-and-or-is-missing
        if !FileManager.default.fileExists(atPath: documentsUrl.path) {
            try? FileManager.default.createDirectory(at: documentsUrl, withIntermediateDirectories: true, attributes: nil)
        }
        #endif
        
        let databaseName = modelName + ".sqlite"
        let persistentStoreUrl = documentsUrl.appendingPathComponent(databaseName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl, options: options)
        } catch {
            QBLog.error("FatalError adding persistent store: \(error)")
            return nil
        }
    }
    
}
