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
    private var trackingId: String?
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
        
        trackingId = id
        configurationManager = QBConfigurationManager(withTrackingId: id, withDeleagte: self)
        eventManager = QBEventManager()
        sessionManager = QBSessionManager()
    }
    
    func sendEvent(type: String, data: String) {
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
        sessionManager?.eventAdded(type: QBEventType(type: type), timestampInMS: timestampInMs)
        if let session = sessionManager?.session {
            let context = QBContextEntity(withSession: session, lookup: lookupManager?.lookup)
            // TODO: fill batchTs, I think filling should be in QBEventManager
            let typeWithVertical = configurationManager.configuration.vertical + type
            
            let meta = QBMetaEntity(id: NSUUID().uuidString, ts: timestampInMs, trackingId: trackingId, type: typeWithVertical, source: session.deviceInfo.getOsNameAndVersion(), seq: session.sequenceEventNumber, batchTs: 123)
            let event = QBEventEntity(type: type, eventData: data, context: context, meta: meta, session: nil)
            eventManager?.addEventInQueue(event: event)
        }
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
        if self.lookupManager == nil, let configurationManager = self.configurationManager, let trackingId = self.trackingId {
            lookupManager = QBLookupManager(withConfigurationManager: configurationManager, withTrackingId: trackingId)
            lookupManager?.delegate = self
        }
        eventManager?.configurationManager = self.configurationManager
    }
}

extension QBTracker: QBLookupManagerDelegate {
    func lookupUpdateSuccessful() {
        if let lookup = lookupManager?.lookup {
            sessionManager?.fillSessionProperties(fromLookup: lookup)
            sessionManager?.sendSessionEvent()
        }
    }
    
    func lookupUpdateFailed() {
        sessionManager?.sendSessionEvent()
    }

}
