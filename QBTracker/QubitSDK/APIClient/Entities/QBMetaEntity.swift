//
//  QBMetaEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBMetaEntity: Codable {
    let id: String
    let ts: Int
    let trackingId: String
    let type: String
    let source: String
    let seq: Int
    let batchTs: Int
}
