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
    var lastEventTimestampInMS: Int64
    var sessionStartTimestampInMS: Int64
    var viewNumber: Int
    var viewTimestampInMS: Int64
    var sessionViewNumber: Int
    var sequenceEventNumber: Int
    let deviceInfo: QBDeviceInfoEntity
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.sessionId = (try? values.decode(String.self, forKey: .sessionId)) ?? DefaultValues.sessionId
        self.sessionNumber = (try? values.decode(Int.self, forKey: .sessionNumber)) ?? DefaultValues.sessionNumber
        self.lastEventTimestampInMS = (try? values.decode(Int64.self, forKey: .lastEventTimestampInMS)) ?? DefaultValues.lastEventTimestampInMS
        self.sessionStartTimestampInMS = (try? values.decode(Int64.self, forKey: .sessionStartTimestampInMS)) ?? DefaultValues.sessionStartTimestampInMS
        self.viewNumber = (try? values.decode(Int.self, forKey: .viewNumber)) ?? DefaultValues.viewNumber
        self.viewTimestampInMS = (try? values.decode(Int64.self, forKey: .viewTimestampInMS)) ?? DefaultValues.viewTimestampInMS
        self.sessionViewNumber = (try? values.decode(Int.self, forKey: .sessionViewNumber)) ?? DefaultValues.sessionViewNumber
        self.sequenceEventNumber = (try? values.decode(Int.self, forKey: .sequenceEventNumber)) ?? DefaultValues.sequenceEventNumber
    
        deviceInfo = QBDeviceInfoEntity()
    }
    
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
        static let lastEventTimestampInMS: Int64 = 0
        static let sessionStartTimestampInMS: Int64 = 0
        static let viewNumber = 0
        static let viewTimestampInMS: Int64 = 0
        static let sessionViewNumber = 0
        static let sequenceEventNumber = 0
    }
}
