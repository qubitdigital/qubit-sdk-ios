//
//  QBSessionEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 04/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import UIKit

struct QBSession: Codable {
    var sessionId: String
    var sessionNumber: Int
    var lastEventTimestampInMS: Int
    var sessionStartTimestampInMS: Int
    var viewNumber: Int
    var viewTimestampInMS: Int
    var sessionViewNumber: Int
    var sequenceEventNumber: Int
    let deviceInfo: QBDeviceInfoEntity
    
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
        
        if let lastEventTimestampInMS = try? values.decode(Int.self, forKey: .lastEventTimestampInMS) {
            self.lastEventTimestampInMS = lastEventTimestampInMS
        } else {
            self.lastEventTimestampInMS = DefaultValues.lastEventTimestampInMS
        }
        
        if let sessionStartTimestampInMS = try? values.decode(Int.self, forKey: .sessionStartTimestampInMS) {
            self.sessionStartTimestampInMS = sessionStartTimestampInMS
        } else {
            self.sessionStartTimestampInMS = DefaultValues.sessionStartTimestampInMS
        }
        
        if let viewNumber = try? values.decode(Int.self, forKey: .viewNumber) {
            self.viewNumber = viewNumber
        } else {
            self.viewNumber = DefaultValues.viewNumber
        }
        
        if let viewTimestampInMS = try? values.decode(Int.self, forKey: .viewTimestampInMS) {
            self.viewTimestampInMS = viewTimestampInMS
        } else {
            self.viewTimestampInMS = DefaultValues.viewTimestampInMS
        }
        
        if let sessionViewNumber = try? values.decode(Int.self, forKey: .sessionViewNumber) {
            self.sessionViewNumber = sessionViewNumber
        } else {
            self.sessionViewNumber = DefaultValues.sessionViewNumber
        }
        
        if let sequenceEventNumber = try? values.decode(Int.self, forKey: .sequenceEventNumber) {
            self.sequenceEventNumber = sequenceEventNumber
        } else {
            self.sequenceEventNumber = DefaultValues.sequenceEventNumber
        }
        
        deviceInfo = QBDeviceInfoEntity()
    }
    // swiftlint:enable function_body_length
    
    init() {
        sessionId = DefaultValues.sessionId
        sessionNumber = DefaultValues.sessionNumber
        lastEventTimestampInMS = DefaultValues.lastEventTimestampInMS
        sessionStartTimestampInMS = DefaultValues.sessionStartTimestampInMS
        viewNumber = DefaultValues.viewNumber
        viewTimestampInMS = DefaultValues.viewTimestampInMS
        sessionViewNumber = DefaultValues.sessionViewNumber
        sequenceEventNumber = DefaultValues.sequenceEventNumber
        deviceInfo = QBDeviceInfoEntity()
    }
}

// MARK: - Default values
extension QBSession {
    private struct DefaultValues {
        static let sessionId = ""
        static let sessionNumber = 0
        static let lastEventTimestampInMS = 0
        static let sessionStartTimestampInMS = 0
        static let viewNumber = 0
        static let viewTimestampInMS = 0
        static let sessionViewNumber = 0
        static let sequenceEventNumber = 0
    }
}
