//
//  QBSessionManager.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBSessionManager {

    var session: QBSessionEntity {
        if self.isSessionValid() {
            return currentSession
        } else {
            startNewSession()
            return currentSession
        }
    }
    
    private var currentSession: QBSessionEntity
    private let sessionTime: Double = 1800
    
    init() {
        guard let lastSession = UserDefaults.standard.session else {
            self.currentSession = QBSessionEntity()
            return
        }
        self.currentSession = lastSession
        self.startNewSession()
    }
    
    private func startNewSession() {
        self.currentSession.sessionNumber += 1
        self.currentSession.sessionViewNumber = 0
        self.currentSession.sequenceNumber = 0
        
//      let oldTimeStamp = self.session.sessionTimestamp
        let timestamp = Date().timeIntervalSince1970
        let timestampString = NSNumber(value: timestamp).stringValue
        let newSessionId = timestampString.md5
        self.currentSession.sessionId = newSessionId
        
        self.currentSession.sessionTimestamp = timestamp
        self.currentSession.sessionStartTimestamp = timestamp
        
        self.saveSession()
        //TODO: send session event
    }
    
    private func saveSession() {
        UserDefaults.standard.session = self.currentSession
    }
    
    func increaseViewNumber() {
        self.currentSession.viewNumber += 1
        self.currentSession.sessionViewNumber += 1
        self.currentSession.viewTimestamp = Date().timeIntervalSince1970
        self.saveSession()
    }
    
    private func isSessionValid() -> Bool {
        let currentTimestamp = Date().timeIntervalSince1970
        return currentTimestamp < self.currentSession.sessionTimestamp + sessionTime
    }
    
    // TODO: Look like it's don't needed
//    func newSequenceNumber() -> Int {
//        sequenceNumber += 1
//        return sequenceNumber
//    }
    
}
