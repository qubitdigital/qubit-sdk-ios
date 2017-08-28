//
//  QBTrackerInit.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

@objc
public class QBTracker: NSObject {
    
    @objc
    public static var shared: QBTracker = QBTracker()
    
    private var configurationManager: QBConfigurationManager?
    private var lookupManager: QBLookupManager?
    private var sessionId: String?
    
    override private init() {
        super.init()
    }
    
    @objc(initializeWithTrackingId:)
    public func initialize(withTrackingId id: String) {
        QBLog.info("QBTracker Initalization...")
        
        configurationManager = QBConfigurationManager(with: id)
        if let configurationManager = configurationManager {
            lookupManager = QBLookupManager(withConfigurationManager: configurationManager, withTrakingId: id)
        }
//        sessionId = QBSessionManager.shared.getValidSessionId()
    }
    
    @objc(sendEventWithType:data:)
    public func sendEvent(type: String, data: String) {
        
    }

}
