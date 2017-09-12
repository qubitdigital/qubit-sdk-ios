//
//  QBTracker.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 29/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBTracker {
    
    static let shared: QBTracker = QBTracker()
    
    private var configurationManager: QBConfigurationManager?
    private var lookupManager: QBLookupManager?
    private var eventManager: QBEventManager?
    private var sessionManager: QBSessionManager?
    
    private init() {}
    
    func start(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.disabled) {
        QBLog.logLevel = logLevel
        QBLog.info("QBTracker Initalization...")

        assert(!id.isEmpty, "Tracking id cannot be empty")
        if id.isEmpty {
            QBLog.error("Tracking id cannot be empty")
            return
        }
        
        let configurationManager = QBConfigurationManager(withTrackingId: id, withDeleagte: self)
        self.configurationManager = configurationManager
        let lookupManager = QBLookupManager(withConfigurationManager: configurationManager)
        self.lookupManager = lookupManager
        let sessionManager = QBSessionManager()
        self.sessionManager = sessionManager
        eventManager = QBEventManager(withConfigurationManager: configurationManager, sessionManager: sessionManager, lookupManager: lookupManager)
    }
    
    func sendEvent(type: String, data: String) {
        guard let eventManager = self.eventManager else {
            QBLog.error("Please call QubitSDK.start(withTrackingId: \"YOUR_TRACKING_ID\"), before sending events")
            return
        }
        
        eventManager.sendEvent(type: type, data: data)
    }
	
	func stop() {
		eventManager = nil
		configurationManager = nil
		lookupManager = nil
        sessionManager = nil
        QBLog.info("tracker stoped")
	}
    
}

extension QBTracker {
    func createEvent(type: String, dictionary: [String: Any]) -> QBEventEntity? {
        return QBEventEntity.event(type:type, dictionary: dictionary)
    }
    
    func sendEvent(event: QBEventEntity) {
        
        guard let trackingId = self.trackingId else {
            QBLog.error("TrakingId is nil, Please call QubitSDK.start(withTrackingId: \"YOUR_TRACKING_ID\"), before sending events")
            return
        }
        
        guard let configurationManager = self.configurationManager else {
            QBLog.error("Please call QubitSDK.start(withTrackingId: \"YOUR_TRACKING_ID\"), before sending events")
            return
        }
        
        if configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration")
            return
        }
        
        let timestampInMs = Date().timeIntervalSince1970InMs
        sessionManager?.eventAdded(type: QBEventType(type: event.type), timestampInMS: timestampInMs)
        if let session = sessionManager?.session {
            eventManager?.addEventInQueue(event: event)
        } else {
            QBLog.info("Sending events disabled, session has not been established")
        }
    }
}

extension QBTracker: QBConfigurationManagerDelegate {
    func configurationUpdated() {
        eventManager?.configurationUpdated()
        lookupManager?.configurationUpdated()
    }
}
