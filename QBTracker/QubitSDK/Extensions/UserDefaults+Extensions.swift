//
//  UserDefaults+Extensions.swift
//  QubitSDK
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
                synchronize()
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
                synchronize()
            }
        }
    }
    
    var session: QBSession? {
        get {
            if let sessionData = data(forKey: #function), let session = try? JSONDecoder().decode(QBSession.self, from: sessionData) {
                return session
            }
            
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: #function)
                synchronize()
            }
        }
    }
}
