//
//  QBEvent.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBEventEntity: Codable {
    let type: String
    let eventData: String
    
    let context: QBContextEntity
    let meta: QBMetaEntity
}
