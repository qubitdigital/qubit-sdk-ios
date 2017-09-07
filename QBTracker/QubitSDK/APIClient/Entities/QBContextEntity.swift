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
    
    let timeZoneOffset: Int
    let viewTs: Int
    let sessionTs: Int
    
    struct QBLifetimeValue: Codable {
        let value: Int
        let currency = "USD"
    }

}

extension QBContextEntity {
    init(withSession session: QBSessionEntity, lookup: QBLookupEntity?) {
        self.id = QBDevice.getId()
        self.sample = String(QBDevice.getId().hashValue)
        self.viewNumber = session.viewNumber
        self.sessionNumber = session.sessionNumber
        self.sessionViewNumber = session.sessionViewNumber
        
        self.conversionNumber = lookup?.conversionNumber
        self.conversionCycleNumber = lookup?.conversionCycleNumber
        var lifeTimeValueTemp: QBLifetimeValue?
        if let lifeTimeInt = lookup?.lifetimeValue {
            lifeTimeValueTemp = QBLifetimeValue(value: lifeTimeInt)
        }
        self.lifetimeValue = lifeTimeValueTemp
        // TODO: set timezone offset
        self.timeZoneOffset = 0
        self.viewTs = Int(session.viewTimestamp)
        self.sessionTs = Int(session.sessionStartTimestamp)
    }
    
    func fillQBContextEvent(context: inout QBContextEvent) -> QBContextEvent {
        context.id = self.id
        context.sample = self.sample
        context.viewNumber = NSNumber(value: self.viewNumber)
        context.sessionNumber = NSNumber(value: self.sessionNumber)
        context.sessionViewNumber = NSNumber(value: self.sessionViewNumber)
        if let conversionNumber = self.conversionNumber {
            context.conversionNumber = NSNumber(value: conversionNumber)
        }
        if let conversionCycleNumber = self.conversionCycleNumber {
            context.conversionCycleNumber = NSNumber(value: conversionCycleNumber)
        }
        if let lifetimeValue = self.lifetimeValue {
            context.lifetimeValue = NSNumber(value: lifetimeValue.value)
            context.lifetimeCurrency = lifetimeValue.currency
        }
        context.timeZoneOffset = NSNumber(value: self.timeZoneOffset)
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
            let viewTs = context.viewTs?.intValue,
            let sessionTs = context.sessionTs?.intValue
        else { return nil }
        
        var lifeTimeValue: QBLifetimeValue?
        if let lifeTimeInt = context.lifetimeValue?.intValue {
            lifeTimeValue = QBLifetimeValue(value: lifeTimeInt)
        }
        
        let contextEntity = QBContextEntity(id: id, sample: sample, viewNumber: viewNumber, sessionNumber: sessionNumber, sessionViewNumber: sessionViewNumber, conversionNumber: context.conversionNumber?.intValue, conversionCycleNumber: context.conversionCycleNumber?.intValue, lifetimeValue: lifeTimeValue, timeZoneOffset: timeZoneOffset, viewTs: viewTs, sessionTs: sessionTs)
        return contextEntity
    }
}
