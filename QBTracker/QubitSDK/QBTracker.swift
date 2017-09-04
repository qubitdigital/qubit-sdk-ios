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
    private var sessionId: String?
    private var trackingId: String?
    private var eventManager: QBEventManager?
    
    private var trackerAleradyStarted: Bool {
        return configurationManager != nil && eventManager != nil && trackingId != nil
    }

    private init() {}
    
    func start(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.disabled) {
        QBLog.logLevel = logLevel
        QBLog.info("QBTracker Initalization...")

        assert(!id.isEmpty, "Tracking id cannot be empty")
        
        trackingId = id
        configurationManager = QBConfigurationManager(withTrackingId: id, withDeleagte: self)
        eventManager = QBEventManager()
		//sessionId = QBSessionManager.shared.getValidSessionId()
    }
    
    func sendEvent(type: String, data: String) {
        guard trackerAleradyStarted else {
            print("Please call QubitSDK.start(withTrackingId: \"YOUR_TRACKING_ID\"), before sending events")
            return
        }
        if let disabled = configurationManager?.configuration.disabled, disabled {
            QBLog.info("Sending events disabled in configuration")
            return
        }

        let event = QBEventEntity(type: type, eventData: data)
        eventManager?.queue(event: event)
    }
	
	func stop() {
		eventManager = nil
		configurationManager = nil
		lookupManager = nil
        QBLog.info("tracker stoped")
	}
    
}

extension QBTracker: QBConfigurationManagerDelegate {
    func configurationUpdated() {
        if self.lookupManager == nil, let configurationManager = self.configurationManager, let trackingId = self.trackingId {
            lookupManager = QBLookupManager(withConfigurationManager: configurationManager, withTrackingId: trackingId)
        }
        eventManager?.configurationManager = self.configurationManager
    }
}
