//
//  QBEvent+CoreDataProperties.swift
//  QubitSDK
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
    @NSManaged var context: QBContextEvent?
    @NSManaged var meta: QBMetaEvent?
    
}

extension QBContextEvent {
    
    @NSManaged var id: String?
    @NSManaged var sample: String?
    @NSManaged var viewTs: NSNumber?
    @NSManaged var viewNumber: NSNumber?
    @NSManaged var timeZoneOffset: NSNumber?
    @NSManaged var sessionTs: NSNumber?
    @NSManaged var sessionNumber: NSNumber?
    @NSManaged var sessionViewNumber: NSNumber?
    @NSManaged var lifetimeValue: NSNumber?
    @NSManaged var lifetimeCurrency: String?
    @NSManaged var conversionCycleNumber: NSNumber?
    @NSManaged var conversionNumber: NSNumber?
    
    @NSManaged var event: QBEvent?
    
}

extension QBMetaEvent {
    @NSManaged var id: String?
    @NSManaged var source: String?
    @NSManaged var trackingId: String?
    @NSManaged var type: String?
    @NSManaged var batchTs: NSNumber?
    @NSManaged var seq: NSNumber?
    @NSManaged var ts: NSNumber?
    
    @NSManaged var event: QBEvent?

}
