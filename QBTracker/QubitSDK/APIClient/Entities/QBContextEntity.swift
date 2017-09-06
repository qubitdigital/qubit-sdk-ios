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
    
    let conversionNumber: Int // lookup
    let conversionCycleNumber: Int // lookup
    
    let lifetimeValue: QBLifetimeValue // lookup
    let lifetimeCurrency: String
    
    let timeZoneOffset: Int
    let viewTs: Int
    let sessionTs: Int
    
    struct QBLifetimeValue: Codable {
        let value: Int
        let currency = "USD"
    }
}


extension QBContextEntity {
    func fillQBContextEvent(context: inout QBContextEvent) -> QBContextEvent {
        context.id = self.id
        context.sample = self.sample
        context.viewNumber = NSNumber(value: self.viewNumber)
        context.sessionNumber = NSNumber(value: self.sessionNumber)
        context.sessionViewNumber = NSNumber(value: self.sessionViewNumber)
        context.conversionNumber = NSNumber(value: self.conversionNumber)
        context.conversionCycleNumber = NSNumber(value: self.conversionCycleNumber)
        context.lifetimeValue = NSNumber(value: self.lifetimeValue.value)
        context.lifetimeCurrency = self.lifetimeCurrency
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
            let conversionNumber = context.conversionNumber?.intValue,
            let conversionCycleNumber = context.conversionCycleNumber?.intValue,
            let lifetimeValue = context.lifetimeValue?.intValue,
            let lifetimeCurrency = context.lifetimeCurrency,
            let timeZoneOffset = context.timeZoneOffset?.intValue,
            let viewTs = context.viewTs?.intValue,
            let sessionTs = context.sessionTs?.intValue
        else { return nil }
        let contextEntity = QBContextEntity(id: id, sample: sample, viewNumber: viewNumber, sessionNumber: sessionNumber, sessionViewNumber: sessionViewNumber, conversionNumber: conversionNumber, conversionCycleNumber: conversionCycleNumber, lifetimeValue: QBLifetimeValue(value: lifetimeValue), lifetimeCurrency: lifetimeCurrency, timeZoneOffset: timeZoneOffset, viewTs: viewTs, sessionTs: sessionTs)
        return contextEntity
    }
}
