//
//  QBLookupManager.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBLookupManager {
    
    var lookup: QBLookupEntity? {
        if let remoteLookup = self.remoteLookup {
            QBLog.verbose("used remote lookup")
            return remoteLookup
        }
        
        if let lastSavedRemoteLookup = UserDefaults.standard.lastSavedRemoteLookup {
            QBLog.verbose("used last saved remote lookup")
            return lastSavedRemoteLookup
        }

        return nil
    }
    
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
    private var reachability = QBReachability()
    
    init(configurationManager: QBConfigurationManager) {
        self.configurationManager = configurationManager
        self.lastUpdateTimeStamp = 0
        try? reachability?.startNotifier()
        downloadLookup()
    }
    
    func configurationUpdated() {
        if shouldUpdateLookup() {
            downloadLookup()
        }
    }
    
    private func downloadLookup() {
        QBLog.mark()
        
        guard configurationManager.isConfigurationLoaded else {
            QBLog.info("Configuration is loading, so lookup will be loaded after load config")
            return
        }
        
        if configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration, so download lookup makes no sense")
            return
        }
        
        if reachability?.isReachable == false {
            QBLog.error("Not connected to the Internet")
            return
        }
        
        let lookupService = QBLookupServiceImp(withConfigurationManager: self.configurationManager)
        
        lookupService.getLookup(forDeviceId: QBDevice.getId()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let lookup):
                QBLog.debug("userDefaults = \(UserDefaults.standard.lastSavedRemoteLookup.debugDescription)")
                self.remoteLookup = lookup
            case .failure(let error):
                QBLog.error("error = \(error)")
            }
        }
    }
    
    private func shouldUpdateLookup() -> Bool {
        if self.remoteLookup == nil {
            return true
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        QBLog.verbose("lookup current timestamp = \(timestamp), last update timestamp = \(lastUpdateTimeStamp), diff = \(timestamp - lastUpdateTimeStamp)")
        if timestamp > lastUpdateTimeStamp + self.configurationManager.configuration.lookupReloadIntervalInSeconds() {
            return true
        }
        return false
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
