//
//  QBLookupEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBLookupEntity: Codable {
    
    let ipLocation: QBLocationIp?
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

    struct QBLocationIp: Codable {
        let city: String?
        let cityCode: String?
        let country: String?
        let countryCode: String?
        let latitude: Double?
        let longitude: Double?
        let area: String?
        let areaCode: String?
        let region: String?
        let regionCode: String?
    }
    
}
