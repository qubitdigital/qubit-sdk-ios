//
//  QBEvent+CoreDataProperties.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 30/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//
//

import Foundation
import CoreData


extension QBEvent {

    @nonobjc class func fetchRequest() -> NSFetchRequest<QBEvent> {
        return NSFetchRequest<QBEvent>(entityName: "QBEvent")
    }

    @NSManaged var data: String?
    @NSManaged var dateAdded: NSDate?
    @NSManaged var sendFailed: Bool
    @NSManaged var type: String?

}
