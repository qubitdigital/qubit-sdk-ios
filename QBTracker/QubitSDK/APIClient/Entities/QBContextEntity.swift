//
//  QBContextEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBContextEntity: Codable {
    let id: String
    let sample: String
    let viewNumber: Int // lookup
    let sessionNumber: Int // lookup
    let sessionViewNumber: Int
    
    // Alex(Slack) 1:34 PM:
    // Sorry, yes in that case don't enrich those fields. Its a best effort enrichment. There are only a few that rely on lookup
    // if we recieve events without those feilds enriched, on our backend we add in the values.
    let conversionNumber: Int? // lookup
    let conversionCycleNumber: Int? // lookup
    let lifetimeValue: QBLifetimeValue? // lookup
    
    let timezoneOffset: Int
    let viewTs: Int64
    let sessionTs: Int64
    
    struct QBLifetimeValue: Codable {
        let value: Int
        let currency = "USD"
        
        init?(withValue value: Int?) {
            guard let value = value else {
                return nil
            }
            self.value = value
        }
    }
}

extension QBContextEntity {
    init(withSession session: QBSession, lookup: QBLookupEntity?) {
        self.id = QBDevice.getId()
        self.sample = String(QBDevice.getId().hashValue)
        self.viewNumber = session.viewNumber
        self.sessionNumber = session.sessionNumber
        self.sessionViewNumber = session.sessionViewNumber
        
        self.conversionNumber = lookup?.conversionNumber
        self.conversionCycleNumber = lookup?.conversionCycleNumber
        self.lifetimeValue = QBLifetimeValue(withValue: lookup?.lifetimeValue)
        self.timezoneOffset = (TimeZone.current.secondsFromGMT() / 60)
        self.viewTs = session.viewTimestampInMS
        self.sessionTs = session.sessionStartTimestampInMS
    }
    
    func fillQBContextEvent(context: inout QBContextEvent) -> QBContextEvent {
        context.id = self.id
        context.sample = self.sample
        context.viewNumber = NSNumber(value: self.viewNumber)
        context.sessionNumber = NSNumber(value: self.sessionNumber)
        context.sessionViewNumber = NSNumber(value: self.sessionViewNumber)
        
        context.conversionNumber = self.conversionNumber?.optionalNumber
        context.conversionCycleNumber = self.conversionCycleNumber?.optionalNumber
    
        if let lifetimeValue = self.lifetimeValue {
            context.lifetimeValue = NSNumber(value: lifetimeValue.value)
            context.lifetimeCurrency = lifetimeValue.currency
        }
        context.timeZoneOffset = NSNumber(value: self.timezoneOffset)
        context.viewTs = NSNumber(value: self.viewTs)
        context.sessionTs = NSNumber(value: self.sessionTs)
        return context
    }
    
    static func create(with context: QBContextEvent) -> QBContextEntity? {
        guard
            let id = context.id,
            let sample = context.sample,
            let viewNumber = context.viewNumber?.intValue,
            let sessionNumber = context.sessionNumber?.intValue,
            let sessionViewNumber = context.sessionViewNumber?.intValue,
            let timeZoneOffset = context.timeZoneOffset?.intValue,
            let viewTs = context.viewTs?.int64Value,
            let sessionTs = context.sessionTs?.int64Value
        else { return nil }
        
        let contextEntity = QBContextEntity(id: id, sample: sample, viewNumber: viewNumber, sessionNumber: sessionNumber, sessionViewNumber: sessionViewNumber, conversionNumber: context.conversionNumber?.intValue, conversionCycleNumber: context.conversionCycleNumber?.intValue, lifetimeValue: QBLifetimeValue(withValue: context.lifetimeValue?.intValue), timezoneOffset: timeZoneOffset, viewTs: viewTs, sessionTs: sessionTs)
        return contextEntity
    }
}
