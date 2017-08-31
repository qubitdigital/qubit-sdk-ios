//
//  QubitSDK.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

@objc
public class QubitSDK: NSObject {
    
    private override init() {
    }
    
    /// Start the QubitSDK
    ///
    /// - Parameters:
    ///   - id: trackingId
    ///   - logLevel: QBLogLevel, default = .disabled
    @objc(startWithTrackingId:logLevel:)
    public class func start(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.disabled) {
        QBTracker.shared.start(withTrackingId: id, logLevel: logLevel)
    }
    
    /// Send and event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - data: JSONString of event data
    @objc(sendEventWithType:data:)
    public class func sendEvent(type: String, data: String) {
        QBTracker.shared.sendEvent(type: type, data: data)
    }
    
}

