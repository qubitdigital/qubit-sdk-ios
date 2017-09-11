//
//  QBConfigurationEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBConfigurationEntity: Codable {
    
    let disabled: Bool
    let configurationReloadInterval: Int
    let queueTimeout: Int
    let namespace: String
    let lookupEndpoint: String
    let lookupReloadInterval: Int
    let lookupRequestTimeout: Int
    let vertical: String
    //  AO: If endpoint is defined then data_location should be ignored.
    let endpoint: String
    let dataLocation: String

    // swiftlint:disable function_body_length
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let disabled = try? values.decode(Bool.self, forKey: .disabled) {
            self.disabled = disabled
        } else {
            self.disabled = DefaultValues.disabled
        }
        
        if let configurationReloadInterval = try? values.decode(Int.self, forKey: .configurationReloadInterval) {
            self.configurationReloadInterval = configurationReloadInterval
        } else {
            self.configurationReloadInterval = DefaultValues.configurationReloadInterval
        }
        
        if let queueTimeout = try? values.decode(Int.self, forKey: .queueTimeout) {
            self.queueTimeout = queueTimeout
        } else {
            self.queueTimeout = DefaultValues.queueTimeout
        }
        
        if let namespace = try? values.decode(String.self, forKey: .namespace) {
            self.namespace = namespace
        } else {
            self.namespace = DefaultValues.namespace
        }
        
        if let lookupEndpoint = try? values.decode(String.self, forKey: .lookupEndpoint) {
            self.lookupEndpoint = lookupEndpoint
        } else {
            self.lookupEndpoint = DefaultValues.lookupEndpoint
        }
        
        if let lookupReloadInterval = try? values.decode(Int.self, forKey: .lookupReloadInterval) {
            self.lookupReloadInterval = lookupReloadInterval
        } else {
            self.lookupReloadInterval = DefaultValues.lookupReloadInterval
        }
        
        if let lookupRequestTimeout = try? values.decode(Int.self, forKey: .lookupRequestTimeout) {
            self.lookupRequestTimeout = lookupRequestTimeout
        } else {
            self.lookupRequestTimeout = DefaultValues.lookupRequestTimeout
        }
        
        if let vertical = try? values.decode(String.self, forKey: .vertical) {
            self.vertical = vertical
        } else {
            self.vertical = DefaultValues.vertical
        }
        
        if let dataLocation = try? values.decode(String.self, forKey: .dataLocation) {
            self.dataLocation = dataLocation
        } else {
            self.dataLocation = DefaultValues.dataLocation
        }
        
        if let endpoint = try? values.decode(String.self, forKey: .endpoint) {
            self.endpoint = endpoint
        } else {
            if self.dataLocation == "US" {
                self.endpoint = DefaultValues.endpointUS
            } else {
                self.endpoint = DefaultValues.endpointEU
            }
        }
    }
    // swiftlint:enable function_body_length
    
    init() {
        self.disabled = DefaultValues.disabled
        self.configurationReloadInterval = DefaultValues.configurationReloadInterval
        self.queueTimeout = DefaultValues.queueTimeout
        self.namespace = DefaultValues.namespace
        self.lookupEndpoint = DefaultValues.lookupEndpoint
        self.lookupReloadInterval = DefaultValues.lookupReloadInterval
        self.lookupRequestTimeout = DefaultValues.lookupRequestTimeout
        self.vertical = DefaultValues.vertical
        self.endpoint = DefaultValues.endpointEU
        self.dataLocation = DefaultValues.dataLocation
    }
    
    private enum CodingKeys: String, CodingKey {
        case disabled
        case configurationReloadInterval = "configuration_reload_interval"
        case queueTimeout = "queue_timeout"
        case namespace
        case lookupEndpoint = "lookup_attribute_url"
        case lookupReloadInterval = "lookup_get_request_timeout"
        case lookupRequestTimeout = "lookup_cache_expire_time"
        case vertical
        case endpoint
        case dataLocation = "data_location"
    }
}

// MARK: - Default values
extension QBConfigurationEntity {
    private struct DefaultValues {
        static let disabled = false
        static let configurationReloadInterval = 2
        static let queueTimeout = 60
        static let namespace = ""
        static let lookupEndpoint = "lookup.qubit.com"
        static let lookupReloadInterval = 60
        static let lookupRequestTimeout = 5
        static let vertical = "ec"
        static let dataLocation = "EU"
        static let endpointEU = "gong-eb.qubit.com"
        static let endpointUS = "gong-gc.qubit.com"
    }
    
}

// MARK: - Helpers
extension QBConfigurationEntity {
    func configurationReloadIntervalInSeconds() -> Double {
        return Double(configurationReloadInterval * 60)
    }
    
    func lookupReloadIntervalInSeconds() -> Double {
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
