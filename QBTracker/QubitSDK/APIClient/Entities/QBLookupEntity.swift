//
//  QBLookupEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

public class QBLookupEntity: NSObject, Codable {
    
    let ipLocation: QBLocationIpEntity?
    let ipAddress: String?
    let viewNumber: Int?
    let sessionNumber: Int?
    let conversionNumber: Int?
    let conversionCycleNumber: Int?
    let lifetimeValue: Int?
    let entranceNumber: Int?
    let firstViewTs: Int?
    let lastViewTs: Int?
    let firstConversionTs: Int?
    let lastConversionTs: Int?
}
