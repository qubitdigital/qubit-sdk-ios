//
//  QBDatabase.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

class QBDatabase: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    
    init(completion: @escaping () -> ()) {
        guard let modelUrl = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let queue = DispatchQueue.global(qos: .background)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        queue.async {
            guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            
            let persistentStoreUrl = documentsUrl.appendingPathComponent("DataModel.sqlite")
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl, options: nil)
                DispatchQueue.main.sync(execute: completion)
            } catch {
                fatalError("Error migrating persistent store: \(error)")
            }
        }
    }
    
}
