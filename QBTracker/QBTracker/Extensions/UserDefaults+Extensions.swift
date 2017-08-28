//
//  UserDefaults+Extensions.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension UserDefaults {
    var lastSavedRemoteConfiguration: QBConfigurationEntity? {
        get {
            if let configurationData = data(forKey: #function), let configuration = try? JSONDecoder().decode(QBConfigurationEntity.self, from: configurationData) {
                return configuration
            }
            
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: #function)
            }
        }
    }
    
    var lastSavedRemoteLookup: QBLookupEntity? {
        get {
            if let lookupData = data(forKey: #function), let lookup = try? JSONDecoder().decode(QBLookupEntity.self, from: lookupData) {
                return lookup
            }
            
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: #function)
            }
        }
    }
}
