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
    
    let context: QBContextEntity? = nil
    let meta: QBMetaEntity? = nil
    
    init(type: String, eventData: String) {
        self.type = type
        self.eventData = eventData
    }
}
