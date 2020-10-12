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

final class QBExperiencesEntity: DictionaryInitializable {
    
    var experiencePayloads: [QBExperienceEntity]
    
    init(withDict dict: [String: Any]) throws {
        guard let experienceEntitiesDicts = dict[Keys.experiencePayloads] as? [[String: Any]] else {
            self.experiencePayloads = []
            return
        }
        
        self.experiencePayloads = [QBExperienceEntity]()
        
        for experienceEntityDict in experienceEntitiesDicts {
            guard let callback = experienceEntityDict[Keys.callback] as? String,
                let isControl = experienceEntityDict[Keys.isControl] as? Bool,
                let experienceId = experienceEntityDict[Keys.experienceId] as? Int,
                let variationId = experienceEntityDict[Keys.variationId] as? Int,
                let payload = experienceEntityDict[Keys.payload] as? [String: Any] else {
                    throw QBExperienceError.initFromDictionaryError
            }
            
            self.experiencePayloads.append(QBExperienceEntity(callback: callback, isControl: isControl, experienceId: experienceId, variationId: variationId, payload: payload))
        }
    }
}

public final class QBExperienceEntity: NSObject, NSCoding {

    public let isControl: Bool
    public let experienceId: Int
    public let variationId: Int

    @objc(payload)
    public let payload: [String: Any]
    
    let callback: String
    
    public var asDictionary: [String: Any] {
        var dict = [String: Any]()
        dict[Keys.callback] = callback
        dict[Keys.experienceId] = experienceId
        dict[Keys.isControl] = isControl
        dict[Keys.variationId] = variationId
        dict[Keys.payload] = payload
        return dict
    }
    
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

extension QBExperienceEntity {
    
    @objc(shown)
    public func shown() {
        guard let url = URL(string: self.callback) else {
            QBLog.error("Invalid callback URL in \(#function): \(self.callback)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue

        let jsonDict: [String: Any] = ["id": QBDevice.getId()]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) else {
            QBLog.error("Could not attach deviceId to callback request: \(self.callback)")
            return
        }

        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request).resume()
        QBLog.info("Callback URL: \(self.callback) was invoked")
    }
}

// MARK: - Abstraction over QBExperienceEntity
// This is used basically to run shown() callback, having only callbackURL.
// The rest of fields are obsolete in this case and can be placeholders.
public final class QBExperienceEntityCallback: NSObject {
    
    private let expEntity: QBExperienceEntity
    
    public init(callback: String) {
        self.expEntity = QBExperienceEntity(callback: callback, isControl: false, experienceId: 0, variationId: 0, payload: [:])
    }
    
    @objc(shown)
    public func shown() {
        expEntity.shown()
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
