//
//  QBLookupManager.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBLookupManager {
    
    private var remoteLookup: QBLookupEntity? = nil {
        didSet {
            UserDefaults.standard.lastSavedRemoteLookup = self.remoteLookup
            self.lastUpdateTimeStamp = NSDate().timeIntervalSince1970
            
            self.startTimer()
        }
    }
    private var timer: Timer?
    private var lastUpdateTimeStamp: Double {
        didSet {
            QBLog.verbose("lookup lastUpdateTimeStamp updated = \(lastUpdateTimeStamp)")
        }
    }
    private let configurationManager: QBConfigurationManager
    private let trackingId: String
    
    init(withConfigurationManager configurationManager: QBConfigurationManager, withTrackingId trackingId: String) {
        self.configurationManager = configurationManager
        self.trackingId = trackingId
        self.lastUpdateTimeStamp = 0
        downloadLookup()
    }
    
    private func downloadLookup() {
        QBLog.mark()
        
        let lookupService = QBLookupServiceImp(withConfigurationManager: self.configurationManager, withTrackingId: self.trackingId)
        
        lookupService.getLookup(forDeviceId: QBDevice.getId()) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let lookup):
//                QBLog.debug("lookup = \(lookup)")

                QBLog.debug("userDefaults = \(UserDefaults.standard.lastSavedRemoteLookup.debugDescription)")

                strongSelf.remoteLookup = lookup
            case .failure(let error):
                //TODO: handle failure
                QBLog.error("error = \(error)")
            }
        }
        
    }
    
    private func shouldUpdateLookup() -> Bool {
        let timestamp = NSDate().timeIntervalSince1970
        QBLog.verbose("lookup current timestamp = \(timestamp), last update timestamp = \(lastUpdateTimeStamp), diff = \(timestamp - lastUpdateTimeStamp)")
        if timestamp > lastUpdateTimeStamp + self.configurationManager.configuration.lookupReloadIntervalInSeconds() {
            return true
        }
        return false
    }
    
    func getLookup() -> QBLookupEntity {
        if let remoteLookup = self.remoteLookup {
            return remoteLookup
        }
        
        if let lastSavedRemoteLookup = UserDefaults.standard.lastSavedRemoteLookup {
            return lastSavedRemoteLookup
        }
        
        return QBLookupEntity()
    }
    
}

// MARK: - Timer
extension QBLookupManager {
    private func startTimer() {        
        self.stopTimer()
        let reloadInterval = self.configurationManager.configuration.lookupReloadIntervalInSeconds()
        guard reloadInterval > 0 else {
            return
        }
        
        DispatchQueue.main.async {
            QBLog.verbose("🚀 startTimer")
            self.timer = Timer.scheduledTimer(timeInterval: reloadInterval, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        DispatchQueue.main.async {
            QBLog.verbose("🛑 stopTimer")
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc private func timerTick() {
        QBLog.verbose("⏰ lookup timer tick")
        if self.shouldUpdateLookup() {
            QBLog.debug("Lookup is outdated")
            self.downloadLookup()
        } else {
            QBLog.debug("Lookup is actual")
        }
    }
}
