//
//  QBTrackerInit.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

@objc
public class QubitSDK: NSObject {
    
    private override init() {
    }
    
    
    @objc(initializeWithTrackingId:logLevel:)
    public class func initialize(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.debug) {
        QBTracker.shared.initialize(withTrackingId: id, logLevel: logLevel)
    }
    
    @objc(sendEventWithType:data:)
    public class func sendEvent(type: String, data: String) {
        QBTracker.shared.sendEvent(type: type, data: data)
    }
    
}

