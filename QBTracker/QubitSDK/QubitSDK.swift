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
        
    /// Start the QubitSDK
    ///
    /// - Parameters:
    ///   - id: trackingId
    ///   - logLevel: QBLogLevel, default = .disabled
    @objc(startWithTrackingId:logLevel:)
    public class func start(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.disabled) {
        QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.start(withTrackingId: id, logLevel: logLevel) }
    }
    
    /// Send and event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - data: JSONString of event data
    @objc(sendEventWithType:data:)
    public class func sendEvent(type: String, data: String) {
         QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.sendEvent(type: type, data: data) }
    }
    
    /// Send and event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - dictionary: event representing by dictionary
    @objc(sendEventWithType:dictionary:)
    public class func sendEvent(type: String, dictionary: [String: Any]) {
        if let event: QBEventEntity = QubitSDK.createEvent(type: type, dictionary: dictionary) as? QBEventEntity {
            QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.sendEvent(event: event) }
        }
    }
    
    /// Send and event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - event: QBEventEntity
    @objc(sendEventWithEvent:)
    public class func sendEvent(event: Any?) {
        if let event = event as? QBEventEntity {
             QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.sendEvent(event: event) }
        }
    }
	
    /// Create event
    ///
    /// - Parameters:
    ///   - type: eventType
    ///   - data: json String
    @objc(createEventWithType:data:)
    public class func createEvent(type: String, data: String) -> AnyObject? {
        return QBEventManager.createEvent(type: type, data: data) as AnyObject
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
         QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.stop() }
	}
}

private extension QubitSDK {
    static func handleException() {
        NSSetUncaughtExceptionHandler { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
        signal(SIGABRT) { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
        signal(SIGILL) { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
        signal(SIGSEGV) { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
        signal(SIGFPE) { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
        signal(SIGBUS) { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
        signal(SIGPIPE) { (_) in
            QBLog.error(Thread.callStackSymbols.joined(separator: "\n"))
        }
    }
}
