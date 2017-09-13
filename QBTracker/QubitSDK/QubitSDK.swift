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
    
    /// Send and event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - event: QBEventEntity
    @objc(sendEventWithEvent:)
    public class func sendEvent(event: Any?) {
        if let event = event as? QBEventEntity {
            QBTracker.shared.sendEvent(event: event)
        }
    }
	
    /// Create event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - event: QBEventEntity
    @objc(createEventWithType:dictionary:)
    public class func createEvent(type: String, dictionary: [String: Any]) -> AnyObject? {
        return QBEventManager.createEvent(type: type, dictionary: dictionary) as AnyObject
    }
    
	/// Stop tracking
	@objc(stopTracking)
	public class func stopTracking() {
		QBTracker.shared.stop()
	}
}
