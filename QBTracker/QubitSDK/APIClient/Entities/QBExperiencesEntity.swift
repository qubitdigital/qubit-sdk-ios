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
        guard let experienceEntitiesDicts = dict[Constants.experiencePayloadsKey] as? [[String: Any]] else {
            self.experiencePayloads = []
            return
        }
        
        self.experiencePayloads = [QBExperienceEnity]()
        
        for experienceEntityDict in experienceEntitiesDicts {
            guard let callback = experienceEntityDict[Constants.callbackKey] as? String,
                let isControl = experienceEntityDict[Constants.isControlKey] as? Bool,
                let experienceId = experienceEntityDict[Constants.experienceIdKey] as? Int,
                let variationId = experienceEntityDict[Constants.variationIdKey] as? Int,
                let payload = experienceEntityDict[Constants.payloadKey] as? [String: Any] else {
                    throw QBExperienceError.initFromDictionaryError
            }
            
            self.experiencePayloads.append(QBExperienceEnity(callback: callback, isControl: isControl, experienceId: experienceId, variationId: variationId, payload: payload))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(experiencePayloads, forKey: Constants.experiencePayloadsKey)
    }
    
    init?(coder aDecoder: NSCoder) {
        guard let experiencePayloads = aDecoder.decodeObject(forKey: Constants.experiencePayloadsKey) as? [QBExperienceEnity] else {
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
        aCoder.encode(callback, forKey: Constants.callbackKey)
        aCoder.encode(isControl, forKey: Constants.isControlKey)
        aCoder.encode(experienceId, forKey: Constants.experienceIdKey)
        aCoder.encode(variationId, forKey: Constants.variationIdKey)
        aCoder.encode(payload, forKey: Constants.payloadKey)
    }
    
    public convenience init?(coder aDecoder: NSCoder) {
        guard let callback = aDecoder.decodeObject(forKey: Constants.callbackKey) as? String,
            let payload = aDecoder.decodeObject(forKey: Constants.payloadKey) as? [String: Any] else {
            return nil
        }
        
        self.init(callback: callback,
                  isControl: aDecoder.decodeBool(forKey: Constants.isControlKey),
                  experienceId: aDecoder.decodeInteger(forKey: Constants.experienceIdKey),
                  variationId: aDecoder.decodeInteger(forKey: Constants.variationIdKey),
                  payload: payload)
    }
}

// MARK: - Invoking callback

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

private struct Constants {
    
    static let callbackKey = "callback"
    static let isControlKey = "isControl"
    static let experienceIdKey = "id"
    static let variationIdKey = "variation"
    static let payloadKey = "payload"
    static let experiencePayloadsKey = "experiencePayloads"
}
