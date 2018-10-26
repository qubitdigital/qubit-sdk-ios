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

@objc(QBEvent) extension QBEvent {

    @nonobjc class func fetchRequest() -> NSFetchRequest<QBEvent> {
        return NSFetchRequest<QBEvent>(entityName: "QBEvent")
    }

    @NSManaged var data: String?
    @NSManaged var dateAdded: NSDate?
    @NSManaged var sendFailed: Bool
    @NSManaged var errorRetryCount: NSNumber?
    @NSManaged var type: String?
    @NSManaged var context: QBContextEvent?
    @NSManaged var meta: QBMetaEvent?
    @NSManaged var session: QBSessionEvent?
    
}

@objc(QBContextEvent) extension QBContextEvent {
    
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

@objc(QBMetaEvent) extension QBMetaEvent {
    @NSManaged var id: String?
    @NSManaged var source: String?
    @NSManaged var trackingId: String?
    @NSManaged var type: String?
    @NSManaged var batchTs: NSNumber?
    @NSManaged var seq: NSNumber?
    @NSManaged var ts: NSNumber?
    
    @NSManaged var event: QBEvent?
}

@objc(QBSessionEvent) extension QBSessionEvent {
    @NSManaged var firstViewTs: NSNumber?
    @NSManaged var lastViewTs: NSNumber?
    @NSManaged var firstConversionTs: NSNumber?
    @NSManaged var lastConversionTs: NSNumber?
    @NSManaged var ipLocationCountry: String?
    @NSManaged var ipLocationCountryCode: String?
    @NSManaged var ipLocationRegion: String?
    @NSManaged var ipLocationRegionCode: String?
    @NSManaged var ipLocationArea: String?
    @NSManaged var ipLocationAreaCode: String?
    @NSManaged var ipLocationCity: String?
    @NSManaged var ipLocationCityCode: String?
    @NSManaged var ipLocationLatitude: NSNumber?
    @NSManaged var ipLocationLongitude: NSNumber?
    @NSManaged var ipAddress: String?
    @NSManaged var deviceType: String?
    @NSManaged var deviceName: String?
    @NSManaged var osName: String?
    @NSManaged var osVersion: String?
    @NSManaged var appType: String?
    @NSManaged var appName: String?
    @NSManaged var appVersion: String?
    @NSManaged var screenWidth: NSNumber?
    @NSManaged var screenHeight: NSNumber?
    
    @NSManaged var event: QBEvent?
}
