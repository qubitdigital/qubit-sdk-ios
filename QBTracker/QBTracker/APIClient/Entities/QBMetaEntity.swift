//
//  QBMetaEntity.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBMetaEntity: Codable {
    let id: Int
    let ts: String
    let trackingId: String
    let type: Int
    let source: String
    let seq: Int
}
