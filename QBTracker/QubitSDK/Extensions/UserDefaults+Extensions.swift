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
    
    var lastSavedRemoteExperiences: [QBExperienceEntity]? {
        get {
            guard let data = object(forKey: #function) as? Data,
                let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [QBExperienceEntity] else {
                return nil
            }
            
            return unarchivedData
        }
        
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            set(data, forKey: #function)
        }
    }
    
    var lastExperienceCacheTime: Double? {
        get {
            guard let time = object(forKey: #function) as? Double else {
                return nil
            }
            
            return time
        }
        
        set {
            set(newValue, forKey: #function)
            synchronize()
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
