//
//  QBConfigurationManager.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBConfigurationManager {
    // MARK: Internal
    //static let shared = QBConfigurationManager()
    
    var trackingId: String
    
    private var remoteConfiguration: QBConfigurationEntity? = nil {
        didSet {
            UserDefaults.standard.lastSavedRemoteConfiguration = self.remoteConfiguration
            self.lastUpdateTimeStamp = NSDate().timeIntervalSince1970
            
            self.startTimer()
        }
    }
    
    // MARK: Private
    private var timestamp:Int = 0
    private var timer: Timer?
    private var lastUpdateTimeStamp: Double {
        didSet {
            QBLog.verbose("lastUpdateTimeStamp updated = \(lastUpdateTimeStamp)")
        }
    }

    init(with trackingId: String) {
        self.lastUpdateTimeStamp = 0
        self.trackingId = trackingId
//        [self loadVisitorId];
        QBLog.info("device id = \(QBDevice.getId())")
        downloadConfig()
    }
    
    private func downloadConfig() {
        QBLog.mark()
        defaultConfigurationService.getConfigution(forId: "miquido") { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let config):
                QBLog.debug("config = \(config)")
                
                QBLog.debug("userDefaults = \(UserDefaults.standard.lastSavedRemoteConfiguration.debugDescription)")
                
                strongSelf.remoteConfiguration = config
            case .failure(let error):
                QBLog.error("error = \(error)")
            }
        }
    }
    
    private func shouldUpdateConfiguration() -> Bool {
        let timestamp = NSDate().timeIntervalSince1970
        QBLog.verbose("current timestamp = \(timestamp), last update timestamp = \(lastUpdateTimeStamp), diff = \(timestamp - lastUpdateTimeStamp)")
        if (timestamp > lastUpdateTimeStamp + QBConfigurationEntity.getReleoadIntervalInSeconds(from: self.remoteConfiguration)) {
            return true
        }
        return false;
    }
    
    func getConfiguration() -> QBConfigurationEntity {
        if let remoteConfiguration = self.remoteConfiguration {            
            return remoteConfiguration
        }
        
        if let lastSavedRemoteConfiguration = UserDefaults.standard.lastSavedRemoteConfiguration {
            return lastSavedRemoteConfiguration
        }
        
        return QBConfigurationEntity()
    }

}

// MARK: - Timer
extension QBConfigurationManager {
    private func startTimer() {
        if let timer = self.timer, timer.isValid {
            return
        }
        
        self.stopTimer()
        let reloadInterval = QBConfigurationEntity.getReleoadIntervalInSeconds(from: self.remoteConfiguration)
        guard reloadInterval > 0 else {
            return
        }
        
        DispatchQueue.main.async {
            QBLog.verbose("🚀 startTimer")
            self.timer = Timer.scheduledTimer(timeInterval: reloadInterval, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        QBLog.verbose("🛑 stopTimer")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timerTick() {
        QBLog.verbose("⏰ timer tick")
        if (self.shouldUpdateConfiguration()) {
            QBLog.debug("Config is outdated")
            self.downloadConfig()
        } else {
            QBLog.debug("Config is actual")
        }
    }
}
