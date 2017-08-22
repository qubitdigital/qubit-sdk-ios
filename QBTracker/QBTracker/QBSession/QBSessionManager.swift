//
//  QBSessionManager.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

enum QBSessionKeys: String {
    case sessionId = "sessionId"
    case sessionNumber = "sessionNumber"
    case viewNumber = "viewNumber"
    case viewTimestamp = "viewTimestamp"
    case sessionTimestamp = "sessionTimestamp"
    case sessionStartTimestamp = "sessionStartTimestamp"
    case sessionViewNumber = "sessionViewNumber"
    case sequenceNumber = "sequenceNumber"
}

class QBSessionManager {
    
    static let shared = QBSessionManager()
    
    fileprivate let sessionTime: Double = 1800
    
    var sessionId: String = ""
    var sessionNumber: Int = 0
    var sessionTimestamp: Double = 0.0
    var sessionStartTimestamp: Double = 0.0
    var viewNumber: Int = 0
    var viewTimestamp: Double = 0.0
    var sessionViewNumber: Int = 0
    var sequenceNumber: Int = 0
    
    private init() {
        loadValues()
    }
    
    func getValidSessionId() -> String {
        if !(isSessionValid()) {
            startNewSession(fromView: false)
        } else {
            sessionTimestamp = Date().timeIntervalSince1970
        }
        
        saveValues()
        return sessionId
    }
    
    func increaseViewNumber() -> Bool {
        viewNumber += 1
        viewTimestamp = Date().timeIntervalSince1970
        
        if !isSessionValid() {
            startNewSession(fromView: true)
            return true
        }
        
        return false
    }
    
    func newSequenceNumber() -> Int {
        sequenceNumber = sequenceNumber + 1
        return sequenceNumber
    }
    
    private func startNewSession(fromView: Bool) {
        let previousSessionTimestamp = sessionTimestamp
        
        let currentDateTimeInterval = Date().timeIntervalSince1970
        let currentDateString = NSNumber(value: currentDateTimeInterval).stringValue
        let newSessionId = currentDateString.md5
        
        sessionNumber = sessionNumber + 1
        sessionViewNumber = fromView ? 1 : 0
        sequenceNumber = 0
        sessionTimestamp = currentDateTimeInterval
        sessionStartTimestamp = currentDateTimeInterval
        
        //TODO: Implement QBTrackingManager
        //QBTrackingManager.shared.dispatchSessionEvent(now, withEnd: previousSessionTimestamp)
        
        sessionId = newSessionId
    }
    
    private func isSessionValid() -> Bool {
        let currentTimestamp = Date().timeIntervalSince1970

        return !(currentTimestamp >= sessionTimestamp + sessionTime)
    }
    
    @discardableResult private func loadValues() {
        let userDefaults = UserDefaults.standard
        
        sessionId = userDefaults.object(forKey: QBSessionKeys.sessionId.rawValue) as? String ?? ""
        sessionNumber = userDefaults.object(forKey: QBSessionKeys.sessionNumber.rawValue) as? Int ?? 0
        viewNumber = userDefaults.object(forKey: QBSessionKeys.viewNumber.rawValue) as? Int ?? 0
        viewTimestamp = userDefaults.object(forKey: QBSessionKeys.viewTimestamp.rawValue) as? Double ?? 0.0
        sessionTimestamp = userDefaults.object(forKey: QBSessionKeys.sessionTimestamp.rawValue) as? Double ?? 0.0
        sessionStartTimestamp = userDefaults.object(forKey: QBSessionKeys.sessionStartTimestamp.rawValue) as? Double ?? 0.0
        sessionViewNumber = userDefaults.object(forKey: QBSessionKeys.sessionViewNumber.rawValue) as? Int ?? 0
        sequenceNumber = userDefaults.object(forKey: QBSessionKeys.sequenceNumber.rawValue) as? Int ?? 0
    }
    
    private func saveValues() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(sessionId, forKey: QBSessionKeys.sessionId.rawValue)
        userDefaults.set(sessionNumber, forKey: QBSessionKeys.sessionNumber.rawValue)
        userDefaults.set(viewNumber, forKey: QBSessionKeys.viewNumber.rawValue)
        userDefaults.set(viewTimestamp, forKey: QBSessionKeys.viewTimestamp.rawValue)
        userDefaults.set(sessionTimestamp, forKey: QBSessionKeys.sessionTimestamp.rawValue)
        userDefaults.set(sessionStartTimestamp, forKey: QBSessionKeys.sessionStartTimestamp.rawValue)
        userDefaults.set(sessionViewNumber, forKey: QBSessionKeys.sessionViewNumber.rawValue)
        userDefaults.set(sequenceNumber, forKey: QBSessionKeys.sequenceNumber.rawValue)
        
        userDefaults.synchronize()
    }
}
