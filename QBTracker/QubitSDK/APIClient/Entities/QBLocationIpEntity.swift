//
//  QBLocationIpEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 12/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBLocationIpEntity: Codable {
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
