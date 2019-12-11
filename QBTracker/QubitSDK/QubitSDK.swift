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
    
    /// Return current tracking ID
    public static var trackingId: String = "Unknown. Call QubitSDK.start(...) before any other call."
    
    /// Return current device ID
    public static var deviceId: String {
        return QBDevice.getId()
    }
    
    /// Start the QubitSDK
    ///
    /// - Parameters:
    ///   - id: trackingId
    ///   - logLevel: QBLogLevel, default = .disabled
    @objc(startWithTrackingId:logLevel:)
    public class func start(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.disabled) {
        if logLevel != .disabled {
            QubitSDK.handleException()
        }
        trackingId = id
        QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.start(withTrackingId: id, logLevel: logLevel) }
    }
    
    /// Pauses or resumes event tracking
    ///
    /// - Parameters:
    /// - enable: default: enabled
    @objc(enable:)
    public class func enableTracker(enable: Bool) {
        QBDispatchQueueService.runAsync(type: .qubit) { QBTracker.shared.enableTracker(enable: enable) }
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

    /// Fetch experiences
    ///
    /// - Parameters:
    ///   - ids: experience ids to filter. When empty list, all experiences will be returned.
    ///   - onSuccess: callback when the download succeeds
    ///   - onError: callback when the download fails
    ///   - preview: when 'true', the latest unpublished interation of experience is used
    ///   - ignoreSegments: when 'true', the payloads for all of the experiences will be returned
    ///   - variation: variation of experience to return
    @objc(fetchExperiencesWithIds:onSuccess:onError:preview:variation:ignoreSegments:)
    public class func fetchExperiences(withIds ids: [Int],
                                       onSuccess: @escaping ([QBExperienceEntity]) -> Void,
                                       onError: @escaping (Error) -> Void,
                                       preview: Bool = false,
                                       ignoreSegments: Bool = false,
                                       variation: NSNumber? = nil) {
        QBDispatchQueueService.runAsync(type: .qubit) {
            QBTracker.shared.fetchExperiences(with: ids,
                                              onSuccess: onSuccess,
                                              onError: onError,
                                              preview: preview,
                                              ignoreSegments: ignoreSegments,
                                              variation: variation)
        }
    }
    
    /// Fetch current lookup entity,
    ///
    /// - Returns: nil if there is no lookup yet, entity otherwise
    @objc(getLookupData)
    public class func getLookupData() -> QBLookupEntity? {
        return QBTracker.shared.getLookup()
    }
}

@objc
public class QBTrackerInit: NSObject {
    
    static let sharedInstance: QBTrackerInit = QBTrackerInit()
    
    @objc(applicationDidFinishLaunching)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]")
    func applicationDidFinishLaunching() {}
    
    @objc(applicationEnterForeground)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    func applicationEnterForeground() {}
    
    @objc(initConfig:completion:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    func initConfig(fromForeground: Bool, completion: (() -> Void)?) {}
    
    @objc(invalidateConfigTimer)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    func invalidateConfigTimer() {}
    
    @objc(validateConfigTimer)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    func validateConfigTimer() {}
}

@objc
public class QBTrackerManager: NSObject {
    
    @objc
    @available(*, deprecated, message:"will be removed in next version")
    public static let sharedManager: QBTrackerManager = QBTrackerManager()

    @objc(setTrackingId:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]/QubitSDK.start(withTrackingId)")
    public func setTrackingId(trackingId: String) {}
    
    @objc(setDebugEndpoint:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func setDebugEndpoint(endPointUrl: String) {}
    
    @objc(unsubscribeToTracking)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK, please use [QubitSDK stopTracking]/QubitSDK.stopTracking()")
    public func unsubscribeToTracking() {}
    
    @objc(subscribeToTracking)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK, please use [QubitSDK startWithTrackingId:logLevel:]/QubitSDK.start(withTrackingId)")
    public func subscribeToTracking() {}
    
    @objc(dispatchEvent:withData:)
    @available(*, deprecated, message:"will be removed in next version of SDK, please use [QubitSDK sendEventWithType:dictionary:]/QubitSDK.sendEvent(type,dictionary)")
    public func dispatchEvent(type: String, withData: [String: Any]) {
        QubitSDK.sendEvent(type: type, dictionary: withData)
    }
    
    @objc(dispatchEvent:withStringData:)
    @available(*, deprecated, message:"will be removed in next version of SDK, please use [QubitSDK sendEventWithType:data:]/QubitSDK.sendEvent(type,data)")
    public func dispatchEvent(type: String, withStringData: String) {
        QubitSDK.sendEvent(type: type, data: withStringData)
    }
    
    @objc(dispatchSessionEvent:withEnd:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func dispatchSessionEvent(startTimeStamp: TimeInterval, withEnd: TimeInterval) {}
    
    @objc(getUserID)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func getUserID() -> String {
        return ""
    }
    
    @objc(setStashInfo:key:withCallback:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func setStashInfo(data: String, key: String, withCallback: (Int) -> Void) {}
    
    @objc(setStashInfo:withCallback:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func setStashInfo(key: String, withCallback: (Int, String) -> Void) {}
    
    @objc(setStashInfoMultiple:withCallback:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func setStashInfoMultiple(userkeys: [String], withCallback: (Int, [String: Any]) -> Void) {}
    
    @objc(getSegmentMembershipInfo:withCallback:)
    @available(*, unavailable, message:"this method is unavailable at new version of SDK")
    public func getSegmentMembershipInfo(userId: String, withCallback: (Int, [String]) -> Void) {}
}

@available(*, unavailable, message:"this method is unavailable at new version of SDK")
public let qubit: QBTrackerManager = QBTrackerManager()

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
