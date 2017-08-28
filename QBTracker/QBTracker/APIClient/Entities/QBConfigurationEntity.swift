//
//  QBConfigurationEntity.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBConfigurationEntity: Codable {
    
    let disabled: Bool?
    let configurationReloadInterval: Int?
    let queueTimeout: Int?
    let endpoint: String?
    let namespace: String?
    //  AO: If endpoint is defined then data_location should be ignored.
    let dataLocation: String?
    let lookupEndpoint: String?
    let lookupCacheExpireTime: Int?
    let lookupRequestTimeout: Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let disabled = try? values.decode(Bool.self, forKey: .disabled)
        self.disabled = disabled != nil ? disabled : DefaultValues.disabled
        
        let configurationReloadInterval = try? values.decode(Int.self, forKey: .queueTimeout)
        self.configurationReloadInterval = configurationReloadInterval != nil ? configurationReloadInterval : DefaultValues.configurationReloadInterval

        let queueTimeout = try? values.decode(Int.self, forKey: .queueTimeout)
        self.queueTimeout = queueTimeout != nil ? queueTimeout : DefaultValues.queueTimeout
        
        let dataLocation = try? values.decode(String.self, forKey: .namespace)
        self.dataLocation = dataLocation != nil ? dataLocation : DefaultValues.dataLocation
        
        if let endpoint = try? values.decode(String.self, forKey: .endpoint) {
            self.endpoint = endpoint
        } else {
            if self.dataLocation == "US" {
                self.endpoint = DefaultValues.endpointUS
            } else {
                self.endpoint = DefaultValues.endpointEU
            }
        }
    
        let namespace = try? values.decode(String.self, forKey: .namespace)
        self.namespace = namespace != nil ? namespace : DefaultValues.namespace
        
        let lookupEndpoint = try? values.decode(String.self, forKey: .lookupEndpoint)
        self.lookupEndpoint = lookupEndpoint != nil ? lookupEndpoint : DefaultValues.lookupEndpoint
        
        let lookupCacheExpireTime = try? values.decode(Int.self, forKey: .lookupCacheExpireTime)
        self.lookupCacheExpireTime = lookupCacheExpireTime != nil ? lookupCacheExpireTime : DefaultValues.lookupCacheExpireTime
        
        let lookupRequestTimeout = try? values.decode(Int.self, forKey: .lookupRequestTimeout)
        self.lookupRequestTimeout = lookupRequestTimeout != nil ? lookupRequestTimeout : DefaultValues.lookupRequestTimeout
    }
    
    init() {
        self.disabled = DefaultValues.disabled
        self.configurationReloadInterval = DefaultValues.configurationReloadInterval
        self.queueTimeout = DefaultValues.queueTimeout
        self.endpoint = DefaultValues.endpointEU
        self.namespace = DefaultValues.namespace
        self.dataLocation = DefaultValues.dataLocation
        self.lookupEndpoint = DefaultValues.lookupEndpoint
        self.lookupCacheExpireTime = DefaultValues.lookupCacheExpireTime
        self.lookupRequestTimeout = DefaultValues.lookupRequestTimeout
    }
    
    private enum CodingKeys : String, CodingKey {
        case disabled
        case configurationReloadInterval = "configuration_reload_interval"
        case queueTimeout = "queue_timeout"
        case endpoint
        case namespace
        case dataLocation = "data_location"
        case lookupEndpoint = "lookup_attribute_url"
        case lookupCacheExpireTime = "lookup_get_request_timeout"
        case lookupRequestTimeout = "lookup_cache_expire_time"
    }
}

// MARK: - Default values
extension QBConfigurationEntity {
    private struct DefaultValues {
        static let disabled = false
        static let configurationReloadInterval = 60
        static let queueTimeout = 60
        static let endpointEU = "gong-eb.qubit.com"
        static let endpointUS = "gong-gc.qubit.com"
        static let namespace = ""
        static let dataLocation = "EU"
        static let lookupEndpoint = "lookup.qubit.com"
        static let lookupCacheExpireTime = 60
        static let lookupRequestTimeout = 5
    }
    

}

// MARK: - Helpers
extension QBConfigurationEntity {
    static func getReleoadIntervalInSeconds(from configuration: QBConfigurationEntity?) -> Double {
        guard let configurationReloadInterval = configuration?.configurationReloadInterval else {
            return 0.0
        }
        return Double(configurationReloadInterval * 60)
    }
}
