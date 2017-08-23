//
//  QBConfigurationEntity.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBConfigurationEntity: Codable {
    let sendAutoViewEvents: Bool?
    let sendAutoInteractionEvents: Bool?
    let sendGeoData: Bool?
    let disabled: Bool?
    let configurationReloadInterval: Int?
    let queueTimeout: Int?
    let vertical: String?
    let endpoint: String?
    let schemaVersion: String?
    let propertyId: String?
    let namespace: String?
    
    
    private enum CodingKeys : String, CodingKey {
        case sendAutoViewEvents = "send_auto_view_events"
        case sendAutoInteractionEvents = "send_auto_interaction_events"
        case sendGeoData = "send_geo_data"
        case disabled
        case configurationReloadInterval = "configuration_reload_interval"
        case queueTimeout = "queue_timeout"
        case vertical
        case endpoint
        case schemaVersion
        case propertyId
        case namespace
    }
    
}
