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
    let experienceEndpoint: String
    let experienceCacheTimeout: Int
    
    //  AO: If endpoint is defined then data_location should be ignored.
    let endpoint: String
    let dataLocation: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.disabled = (try? values.decode(Bool.self, forKey: .disabled)) ?? DefaultValues.disabled
        self.configurationReloadInterval = (try? values.decode(Int.self, forKey: .configurationReloadInterval)) ?? DefaultValues.configurationReloadInterval
        self.queueTimeout = (try? values.decode(Int.self, forKey: .queueTimeout)) ?? DefaultValues.queueTimeout
        self.namespace = (try? values.decode(String.self, forKey: .namespace)) ?? DefaultValues.namespace
        self.lookupEndpoint = (try? values.decode(String.self, forKey: .lookupEndpoint)) ?? DefaultValues.lookupEndpoint
        self.lookupReloadInterval = (try? values.decode(Int.self, forKey: .lookupReloadInterval)) ?? DefaultValues.lookupReloadInterval
        self.lookupRequestTimeout = (try? values.decode(Int.self, forKey: .lookupRequestTimeout)) ?? DefaultValues.lookupRequestTimeout
        self.vertical = (try? values.decode(String.self, forKey: .vertical)) ?? DefaultValues.vertical
        self.dataLocation = (try? values.decode(String.self, forKey: .dataLocation)) ?? DefaultValues.dataLocation
        self.experienceEndpoint = (try? values.decode(String.self, forKey: .experienceEndpoint)) ?? DefaultValues.experienceEndpoint
        self.experienceCacheTimeout = (try? values.decode(Int.self, forKey: .experienceCacheTimeout)) ?? DefaultValues.experienceCacheTimeout

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
        self.experienceEndpoint = DefaultValues.experienceEndpoint
        self.experienceCacheTimeout = DefaultValues.experienceCacheTimeout
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
        case experienceEndpoint = "experience_api_host"
        case experienceCacheTimeout = "experience_api_cache_expire_time"
    }
}

// MARK: - Default values
extension QBConfigurationEntity {
    private struct DefaultValues {
        static let disabled = false
        static let configurationReloadInterval = 60
        static let queueTimeout = 60
        static let namespace = ""
        static let lookupEndpoint = "lookup.qubit.com"
        static let lookupReloadInterval = 60
        static let lookupRequestTimeout = 5
        static let vertical = "ec"
        static let dataLocation = "EU"
        static let endpointEU = "gong-eb.qubit.com"
        static let endpointUS = "gong-gc.qubit.com"
        static let experienceEndpoint = "sse.qubit.com"
        static let experienceCacheTimeout = 300
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
    
    func experienceEndpointUrl() -> URL? {
        return self.urlFrom(stringUrl: self.experienceEndpoint)
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
