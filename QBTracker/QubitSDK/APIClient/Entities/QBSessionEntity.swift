//
//  QBSessionEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 04/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBSessionEntity: Codable {
    var sessionId: String
    var sessionNumber: Int
    var sessionTimestamp: Double
    var sessionStartTimestamp: Double
    var viewNumber: Int
    var viewTimestamp: Double
    var sessionViewNumber: Int
    var sequenceNumber: Int
    
    // swiftlint:disable function_body_length
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let sessionId = try? values.decode(String.self, forKey: .sessionId) {
            self.sessionId = sessionId
        } else {
            self.sessionId = DefaultValues.sessionId
        }
        
        if let sessionNumber = try? values.decode(Int.self, forKey: .sessionNumber) {
            self.sessionNumber = sessionNumber
        } else {
            self.sessionNumber = DefaultValues.sessionNumber
        }
        
        if let sessionTimestamp = try? values.decode(Double.self, forKey: .sessionTimestamp) {
            self.sessionTimestamp = sessionTimestamp
        } else {
            self.sessionTimestamp = DefaultValues.sessionTimestamp
        }
        
        if let sessionStartTimestamp = try? values.decode(Double.self, forKey: .sessionStartTimestamp) {
            self.sessionStartTimestamp = sessionStartTimestamp
        } else {
            self.sessionStartTimestamp = DefaultValues.sessionStartTimestamp
        }
        
        if let viewNumber = try? values.decode(Int.self, forKey: .viewNumber) {
            self.viewNumber = viewNumber
        } else {
            self.viewNumber = DefaultValues.viewNumber
        }
        
        if let viewTimestamp = try? values.decode(Double.self, forKey: .viewTimestamp) {
            self.viewTimestamp = viewTimestamp
        } else {
            self.viewTimestamp = DefaultValues.viewTimestamp
        }
        
        if let sessionViewNumber = try? values.decode(Int.self, forKey: .sessionViewNumber) {
            self.sessionViewNumber = sessionViewNumber
        } else {
            self.sessionViewNumber = DefaultValues.sessionViewNumber
        }
        
        if let sequenceNumber = try? values.decode(Int.self, forKey: .sequenceNumber) {
            self.sequenceNumber = sequenceNumber
        } else {
            self.sequenceNumber = DefaultValues.sequenceNumber
        }
    }
    // swiftlint:enable function_body_length
    
    init() {
        sessionId = DefaultValues.sessionId
        sessionNumber = DefaultValues.sessionNumber
        sessionTimestamp = DefaultValues.sessionTimestamp
        sessionStartTimestamp = DefaultValues.sessionStartTimestamp
        viewNumber = DefaultValues.viewNumber
        viewTimestamp = DefaultValues.viewTimestamp
        sessionViewNumber = DefaultValues.sessionViewNumber
        sequenceNumber = DefaultValues.sequenceNumber
    }
}

// MARK: - Default values
extension QBSessionEntity {
    private struct DefaultValues {
        static let sessionId = ""
        static let sessionNumber = 0
        static let sessionTimestamp = 0.0
        static let sessionStartTimestamp = 0.0
        static let viewNumber = 0
        static let viewTimestamp = 0.0
        static let sessionViewNumber = 0
        static let sequenceNumber = 0
    }
}