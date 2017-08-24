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
    let endpoint: URL?
    let schemaVersion: String?
    let propertyId: String?
    let namespace: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let sendAutoViewEvents = try? values.decode(Bool.self, forKey: .sendAutoViewEvents)
        self.sendAutoViewEvents = sendAutoViewEvents != nil ? sendAutoViewEvents : DefaultValues.sendAutoViewEvents
        
        let sendAutoInteractionEvents = try? values.decode(Bool.self, forKey: .sendAutoInteractionEvents)
        self.sendAutoInteractionEvents = sendAutoInteractionEvents != nil ? sendAutoInteractionEvents : DefaultValues.sendAutoInteractionEvents
        
        let sendGeoData = try? values.decode(Bool.self, forKey: .sendGeoData)
        self.sendGeoData = sendGeoData != nil ? sendGeoData : DefaultValues.sendGeoData
        
        let disabled = try? values.decode(Bool.self, forKey: .disabled)
        self.disabled = disabled != nil ? disabled : DefaultValues.disabled
        
        let configurationReloadInterval = try? values.decode(Int.self, forKey: .queueTimeout)
        self.configurationReloadInterval = configurationReloadInterval != nil ? configurationReloadInterval : DefaultValues.configurationReloadInterval

        let queueTimeout = try? values.decode(Int.self, forKey: .queueTimeout)
        self.queueTimeout = queueTimeout != nil ? queueTimeout : DefaultValues.queueTimeout
        
        let vertical = try? values.decode(String.self, forKey: .vertical)
        self.vertical = vertical != nil ? vertical : DefaultValues.vertical
        
        let endpoint = try? values.decode(URL.self, forKey: .endpoint)
        self.endpoint = endpoint != nil ? endpoint : DefaultValues.endpoint
        
        let schemaVersion = try? values.decode(String.self, forKey: .schemaVersion)
        self.schemaVersion = schemaVersion != nil ? schemaVersion : DefaultValues.schemaVersion
        
        let propertyId = try? values.decode(String.self, forKey: .propertyId)
        self.propertyId = propertyId != nil ? propertyId : DefaultValues.propertyId
        
        let namespace = try? values.decode(String.self, forKey: .namespace)
        self.namespace = namespace != nil ? namespace : DefaultValues.namespace
    }
    
    init() {
        self.sendAutoViewEvents = DefaultValues.sendAutoViewEvents
        self.sendAutoInteractionEvents = DefaultValues.sendAutoInteractionEvents
        self.sendGeoData = DefaultValues.sendGeoData
        self.disabled = DefaultValues.disabled
        self.configurationReloadInterval = DefaultValues.configurationReloadInterval
        self.queueTimeout = DefaultValues.queueTimeout
        self.vertical = DefaultValues.vertical
        self.endpoint = DefaultValues.endpoint
        self.schemaVersion = DefaultValues.schemaVersion
        self.propertyId = DefaultValues.propertyId
        self.namespace = DefaultValues.namespace
    }
    
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

// MARK: - Default values
extension QBConfigurationEntity {
    private struct DefaultValues {
        static let sendAutoViewEvents = false
        static let sendAutoInteractionEvents = false
        static let sendGeoData = true
        static let disabled = false
        static let configurationReloadInterval = 60
        static let queueTimeout = 60
        static let vertical = "ec"
        static let endpoint = URL(string: "https://gong-eb.qubit.com/events/raw")
        static let schemaVersion = "3"
        static let propertyId = "1234"
        static let namespace = ""
    }
}

// MARK: - Helpers
extension QBConfigurationEntity {
    static func getReleoadIntervalInSeconds(from configuration: QBConfigurationEntity?) -> Double{
        guard let configurationReloadInterval = configuration?.configurationReloadInterval else {
            return 0.0
        }
        return Double(configurationReloadInterval * 60)
    }
}
