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

@objc
public class QBTrackerInit: NSObject {
    
    static let sharedInstance: QBTrackerInit = QBTrackerInit()
    
    func applicationDidFinishLaunching() {
        
    }
    
    func applicationEnterForeground() {
        
    }
    
    func initConfig(fromForeground: Bool, completion: (() -> Void)?) {
        
    }
    
    func invalidateConfigTimer() {
        
    }
    
    func validateConfigTimer() {
        
    }
}

@objc
public class QBTrackerManager: NSObject {
    
    @objc
    public static let sharedManager: QBTrackerManager = QBTrackerManager()

    @objc(setTrackingId:)
    public func setTrackingId(trackingId: String) {
        
    }
    
    @objc(setDebugEndpoint:)
    public func setDebugEndpoint(endPointUrl: String) {
        
    }
    @objc(unsubscribeToTracking)
    public func unsubscribeToTracking() {
        
    }
    
    @objc(subscribeToTracking)
    public func subscribeToTracking() {
        
    }
    
    @objc(dispatchEvent:withData:)
    public func dispatchEvent(type: String, withData: [String: Any]) {
        
    }
    
    @objc(dispatchEvent:withStringData:)
    public func dispatchEvent(type: String, withStringData: String) {
        
    }
    
    @objc(dispatchSessionEvent:withEnd:)
    public func dispatchSessionEvent(startTimeStamp: TimeInterval, withEnd: TimeInterval) {
        
    }
    
    @objc(getUserID)
    public func getUserID() -> String {
        return ""
    }
    
    @objc(setStashInfo:key:withCallback:)
    public func setStashInfo(data: String, key: String, withCallback: (Int) -> Void) {
        
    }
    
    @objc(setStashInfo:withCallback:)
    public func setStashInfo(key: String, withCallback: (Int, String) -> Void) {
        
    }
    
    @objc(setStashInfoMultiple:withCallback:)
    public func setStashInfoMultiple(userkeys: [String], withCallback: (Int, [String: Any]) -> Void) {
        
    }
    
    @objc(getSegmentMembershipInfo:withCallback:)
    public func getSegmentMembershipInfo(userId: String, withCallback: (Int, [String]) -> Void) {
        
    }
    
}

public let qubit: QBTrackerManager = QBTrackerManager()


