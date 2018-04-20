//
//  QBSessionManager.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBSessionManagerDelegate: class {
    func newSessionStarted()
}

class QBSessionManager {

    weak var delegate: QBSessionManagerDelegate?
    
    var session: QBSession {
        if self.isSessionValid() {
            return currentSession
        } else {
            startNewSession()
            return currentSession
        }
    }
    
    private var currentSession: QBSession
    private let sessionTimeInMS = 1_800_000
    
    init(delegate: QBSessionManagerDelegate) {
        self.delegate = delegate
        guard let lastSession = UserDefaults.standard.session else {
            self.currentSession = QBSession()
            return
        }
        self.currentSession = lastSession
    }
        
    func startNewSession() {
        self.currentSession.sessionNumber += 1
        self.currentSession.sessionViewNumber = 0
        self.currentSession.sequenceEventNumber = 0
        
        let timestampInMS = Date().timeIntervalSince1970InMs
        self.currentSession.lastEventTimestampInMS = timestampInMS
        self.currentSession.sessionStartTimestampInMS = timestampInMS
        
        self.saveSession()
        self.delegate?.newSessionStarted()
    }
    
    private func saveSession() {
        UserDefaults.standard.session = self.currentSession
    }
    
    private func isSessionValid() -> Bool {
        let currentTimestamp = Date().timeIntervalSince1970InMs
        return currentTimestamp < Int64(self.currentSession.lastEventTimestampInMS) + Int64(sessionTimeInMS)
    }
    
    func eventAdded(type: QBEventType, timestampInMS: Int64) {
        switch type {
        case .session:
            return
        case .view:
            self.currentSession.viewNumber += 1
            self.currentSession.sessionViewNumber += 1
            self.currentSession.viewTimestampInMS = timestampInMS
            fallthrough
        case .other:
            self.currentSession.sequenceEventNumber += 1
        }
        self.saveSession()
    }

}
