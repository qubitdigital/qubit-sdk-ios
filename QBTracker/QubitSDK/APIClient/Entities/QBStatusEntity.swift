//
//  QBStatusEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBStatusEntity: Codable {
    let status: QBResponceCodeEntity
    
    struct QBResponceCodeEntity: Codable {
        let message: String
        let code: Int
    }
}
