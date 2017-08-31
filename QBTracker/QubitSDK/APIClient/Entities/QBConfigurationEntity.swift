//
//  QBConfigurationEntity.swift
//  QubitSDK
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
    let lookupReloadInterval: Int?
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
        
        let lookupReloadInterval = try? values.decode(Int.self, forKey: .lookupReloadInterval)
        self.lookupReloadInterval = lookupReloadInterval != nil ? lookupReloadInterval : DefaultValues.lookupReloadInterval
        
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
        self.lookupReloadInterval = DefaultValues.lookupReloadInterval
        self.lookupRequestTimeout = DefaultValues.lookupRequestTimeout
    }
    
    private enum CodingKeys: String, CodingKey {
        case disabled
        case configurationReloadInterval = "configuration_reload_interval"
        case queueTimeout = "queue_timeout"
        case endpoint
        case namespace
        case dataLocation = "data_location"
        case lookupEndpoint = "lookup_attribute_url"
        case lookupReloadInterval = "lookup_get_request_timeout"
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
        static let lookupReloadInterval = 60
        static let lookupRequestTimeout = 5
    }
    
}

// MARK: - Helpers
extension QBConfigurationEntity {
    func configurationReloadIntervalInSeconds() -> Double {
        guard let configurationReloadInterval = self.configurationReloadInterval else {
            return 0.0
        }
        return Double(configurationReloadInterval * 60)
    }
    
    func lookupReloadIntervalInSeconds() -> Double {
        guard let lookupReloadInterval = self.lookupReloadInterval else {
            return 0.0
        }
        return Double(lookupReloadInterval * 60)
    }
    
    func lookupEndpointUrl() -> URL? {
        return self.urlFrom(stringUrl: self.lookupEndpoint)
    }
    
    func mainEndpointUrl() -> URL? {
        return self.urlFrom(stringUrl: self.endpoint)
    }
    
    private func urlFrom(stringUrl: String?) -> URL? {
        guard let endpoint = stringUrl else {
            return nil
        }
        
        let httpPrefix = "http://"
        let httpsPrefix = "https://"
        if endpoint.hasPrefix(httpPrefix) {
            let hostWithHttps = endpoint.replacingOccurrences(of: httpPrefix, with: httpsPrefix)
            return URL(string: hostWithHttps)
        }
        
        if endpoint.hasPrefix(httpsPrefix) {
            return URL(string: endpoint)
        } else {
            return URL(string: "\(httpsPrefix)\(endpoint)")
        }
    }
}
