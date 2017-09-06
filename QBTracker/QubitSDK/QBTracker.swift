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
    
    private var trackerAleradyStarted: Bool {
        return configurationManager != nil && eventManager != nil && trackingId != nil
    }

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
        let context = QBContextEntity(id: QBDevice.getId(), sample: String(QBDevice.getId().hashValue), viewNumber: 1, sessionNumber: 1, sessionViewNumber: 1, conversionNumber: 2, conversionCycleNumber: 2, lifetimeValue: QBContextEntity.QBLifetimeValue(value: 2312), lifetimeCurrency: "USD", timeZoneOffset: 1000, viewTs: 1231312312, sessionTs: 1231312312)
        let meta = QBMetaEntity(id: NSUUID().uuidString, ts: Int(Date().timeIntervalSince1970), trackingId: "miquido", type: "ecProduct", source: "iOS@0.3.1", seq: 3, batchTs: 6)
        
        let event = QBEventEntity(type: type, eventData: data, context: context, meta: meta, session: nil)
        
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
            lookupManager?.delegate = self
        }
        eventManager?.configurationManager = self.configurationManager
    }
}

extension QBTracker: QBLookupManagerDelegate {
    func lookupUpdated() {
        eventManager?.lookupManager = self.lookupManager
        if self.sessionManager == nil {
            self.sessionManager = QBSessionManager()
        }
    }
}
