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
        
        let configurationManager = QBConfigurationManager(withTrackingId: id, delegate: self)
        self.configurationManager = configurationManager
        let lookupManager = QBLookupManager(withConfigurationManager: configurationManager)
        self.lookupManager = lookupManager
        let sessionManager = QBSessionManager(delegate: self)
        self.sessionManager = sessionManager
        eventManager = QBEventManager(withConfigurationManager: configurationManager, sessionManager: sessionManager, lookupManager: lookupManager)
        sessionManager.startNewSession()
    }
    
    func sendEvent(type: String, data: String) {
        guard let eventManager = self.eventManager else {
            QBLog.error("Please call QubitSDK.start(withTrackingId: \"YOUR_TRACKING_ID\"), before sending events")
            return
        }
        if let event = QBEventManager.createEvent(type: type, data: data) {
            eventManager.sendEvent(event: event)
        }
    }
    
    func sendEvent(event: QBEventEntity) {
        guard let eventManager = self.eventManager else {
            QBLog.error("Please call QubitSDK.start(withTrackingId: \"YOUR_TRACKING_ID\"), before sending events")
            return
        }
        eventManager.sendEvent(event: event)
    }
	
	func stop() {
		eventManager = nil
		configurationManager = nil
		lookupManager = nil
        sessionManager = nil
        QBLog.info("tracker stoped")
	}
}

extension QBTracker: QBConfigurationManagerDelegate {
    func configurationUpdated() {
        eventManager?.configurationUpdated()
        lookupManager?.configurationUpdated()
    }
}

extension QBTracker: QBSessionManagerDelegate {
    func newSessionStarted() {
        eventManager?.sendSessionEvent()
    }
}
