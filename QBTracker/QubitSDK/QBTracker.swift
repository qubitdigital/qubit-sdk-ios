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

    private init() {}
    
    func start(withTrackingId id: String, logLevel: QBLogLevel = QBLogLevel.disabled) {
        QBLog.logLevel = logLevel
        QBLog.info("QBTracker Initalization...")

        assert(!id.isEmpty, "Tracking id cannot be empty")
        
        trackingId = id
		
        //TODO: add completions for initializers (ie.  start lookup manager once configuration is fetched.  Start event manager once lookup is fetched).
        configurationManager = QBConfigurationManager(with: id)
        if let configurationManager = configurationManager {
            lookupManager = QBLookupManager(withConfigurationManager: configurationManager, withTrackingId: id)
        }
		
        eventManager = QBEventManager()
		//sessionId = QBSessionManager.shared.getValidSessionId()
    }
    
    func sendEvent(type: String, data: String) {
        let event = QBEventEntity(type: type, eventData: data)
        eventManager?.queue(event: event)
    }
	
	func stop() {
		eventManager = nil
		configurationManager = nil
		lookupManager = nil
	}
}
