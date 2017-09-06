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
    
    let lifetimeValue: Int // lookup
    let lifetimeCurrency: String
    
    let timeZoneOffset: Int
    let viewTs: Int
    let sessionTs: Int
}
