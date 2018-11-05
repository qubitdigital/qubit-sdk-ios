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
    private var experiencesManager: QBExperiencesManager?
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
        
        let experiencesManager = QBExperiencesManager(configurationManager: configurationManager)
        self.experiencesManager = experiencesManager
        
        let lookupManager = QBLookupManager(configurationManager: configurationManager)
        self.lookupManager = lookupManager
        
        let sessionManager = QBSessionManager(delegate: self)
        self.sessionManager = sessionManager
        
        eventManager = QBEventManager(withConfigurationManager: configurationManager, sessionManager: sessionManager, lookupManager: lookupManager)
        
        sessionManager.startNewSession()
        configurationManager.downloadConfig()
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
    
    func getCurrentTrackingId() -> String? {
        return configurationManager?.trackingId
    }
	
	func stop() {
		eventManager = nil
		configurationManager = nil
		lookupManager = nil
        sessionManager = nil
        experiencesManager = nil
        QBLog.info("tracker stoped")
	}
    
    internal func fetchExperiences(with ids: [Int],
                             onSuccess: @escaping ([QBExperienceEnity]) -> Void,
                             onError: @escaping (Error) -> Void,
                             preview: Bool = false,
                             ignoreSegments: Bool = false,
                             variation: NSNumber? = nil) {
        guard let experiencesManager = experiencesManager else {
            QBLog.error("experiencesManager is null")
            return
        }
        
        experiencesManager.downloadParams = (preview: preview,
                                             ignoreSegments: ignoreSegments,
                                             variation: variation?.intValue)
        
        experiencesManager.fetchExperiences(with: ids) { (experiences, error) in
            if let experiences = experiences {
                onSuccess(experiences)
            } else if let error = error {
                onError(error)
            }
        }
    }
}

extension QBTracker: QBConfigurationManagerDelegate {
    func configurationUpdated() {
        eventManager?.configurationUpdated()
        lookupManager?.configurationUpdated()
        experiencesManager?.configurationUpdated()
    }
}

extension QBTracker: QBSessionManagerDelegate {
    func newSessionStarted() {
        eventManager?.sendSessionEvent()
    }
}
