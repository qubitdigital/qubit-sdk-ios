//
//  QBExperienceEntity.swift
//  QubitSDK
//
//  Created by Andrzej Zuzak on 30/10/2018.
//  Copyright © 2018 Qubit. All rights reserved.
//

import Foundation

enum QBExperienceError: Error {
    
    case initFromDictionaryError
}

final class QBExperiencesEntity: NSObject, DictionaryInitializable, NSCoding {
    
    var experiencePayloads: [QBExperienceEnity]
    
    init(withDict dict: [String : Any]) throws {
        guard let experienceEntitiesDicts = dict[Keys.experiencePayloads] as? [[String: Any]] else {
            self.experiencePayloads = []
            return
        }
        
        self.experiencePayloads = [QBExperienceEnity]()
        
        for experienceEntityDict in experienceEntitiesDicts {
            guard let callback = experienceEntityDict[Keys.callback] as? String,
                let isControl = experienceEntityDict[Keys.isControl] as? Bool,
                let experienceId = experienceEntityDict[Keys.experienceId] as? Int,
                let variationId = experienceEntityDict[Keys.variationId] as? Int,
                let payload = experienceEntityDict[Keys.payload] as? [String: Any] else {
                    throw QBExperienceError.initFromDictionaryError
            }
            
            self.experiencePayloads.append(QBExperienceEnity(callback: callback, isControl: isControl, experienceId: experienceId, variationId: variationId, payload: payload))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(experiencePayloads, forKey: Keys.experiencePayloads)
    }
    
    init?(coder aDecoder: NSCoder) {
        guard let experiencePayloads = aDecoder.decodeObject(forKey: Keys.experiencePayloads) as? [QBExperienceEnity] else {
            return nil
        }
        
        self.experiencePayloads = experiencePayloads
    }
}

public final class QBExperienceEnity: NSObject, NSCoding {

    let callback: String
    let isControl: Bool
    let experienceId: Int
    let variationId: Int
    let payload: [String: Any]
    
    init(callback: String, isControl: Bool, experienceId: Int, variationId: Int, payload: [String: Any]) {
        self.callback = callback
        self.isControl = isControl
        self.experienceId = experienceId
        self.variationId = variationId
        self.payload = payload
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(callback, forKey: Keys.callback)
        aCoder.encode(isControl, forKey: Keys.isControl)
        aCoder.encode(experienceId, forKey: Keys.experienceId)
        aCoder.encode(variationId, forKey: Keys.variationId)
        aCoder.encode(payload, forKey: Keys.payload)
    }
    
    public convenience init?(coder aDecoder: NSCoder) {
        guard let callback = aDecoder.decodeObject(forKey: Keys.callback) as? String,
            let payload = aDecoder.decodeObject(forKey: Keys.payload) as? [String: Any] else {
            return nil
        }
        
        self.init(callback: callback,
                  isControl: aDecoder.decodeBool(forKey: Keys.isControl),
                  experienceId: aDecoder.decodeInteger(forKey: Keys.experienceId),
                  variationId: aDecoder.decodeInteger(forKey: Keys.variationId),
                  payload: payload)
    }
}

// MARK: - Invoking callback URL

extension QBExperienceEnity {
    
    public func shown() {
        QBDispatchQueueService.runAsync(type: .experiences) { [weak self] in
            guard let self = self else { return }
            
            guard let url = URL(string: self.callback) else {
                QBLog.error("Invalid callback URL in \(#function): \(self.callback)")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            URLSession.shared.dataTask(with: request).resume()
            
            QBLog.info("Callback URL: \(self.callback) was invoked")
        }
    }
}

// MARK: - Constants

private struct Keys {
    
    static let callback = "callback"
    static let isControl = "isControl"
    static let experienceId = "id"
    static let variationId = "variation"
    static let payload = "payload"
    static let experiencePayloads = "experiencePayloads"
}
