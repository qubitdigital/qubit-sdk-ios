//
//  QBTrackerInit.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

@objc
public class QubitSDK: NSObject {
    
    @objc
    public static var shared: QubitSDK = QubitSDK()
    
    private var configurationManager: QBConfigurationManager?
    private var sessionId: String?
    private var trackingId: String?
    private let eventManger = QBEventManager()
    
    override private init() {
        super.init()
    }
    
    @objc(initializeWithTrackingId:)
    public func initialize(withTrackingId id: String) {
        QBLog.info("QBTracker Initalization...")
        
        assert(id.isEmpty, "Tracking id cannot be empty")
        
        trackingId = id
        configurationManager = QBConfigurationManager(with: id)
        sessionId = QBSessionManager.shared.getValidSessionId()
    }
    
    @objc(sendEventWithType:data:)
    public func sendEvent(type: String, data: String) {
        
    }

}
