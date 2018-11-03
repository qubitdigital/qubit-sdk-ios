//
//  QBExperienceEntity.swift
//  QubitSDK
//
//  Created by Andrzej Zuzak on 30/10/2018.
//  Copyright © 2018 Qubit. All rights reserved.
//

import Foundation

struct QBExperiencesEntity: Codable {
    
    let experiencePayloads: [QBExperienceEnity]
}

public class QBExperienceEnity: NSObject, Codable {
    
    let callback: String
    let isControl: Bool
    let experienceId: Int
    let variationId: Int
//    let payload: [String: String]
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        callback = try container.decode(String.self, forKey: .callback)
        isControl = try container.decode(Bool.self, forKey: .isControl)
        experienceId = try container.decode(Int.self, forKey: .experienceId)
        variationId = try container.decode(Int.self, forKey: .variationId)
        
//        let payload = try container.nestedContainer(keyedBy: CodingKey.self, forKey: .payload)
    }
    
    public func encode(to encoder: Encoder) throws { }
    
    private enum CodingKeys: String, CodingKey {
        case isControl
        case experienceId = "id"
        case callback
        case variationId = "variation"
        case payload
    }
}

// MARK: - Invoking callback

struct UnknownValue: Codable {
    
    
}
