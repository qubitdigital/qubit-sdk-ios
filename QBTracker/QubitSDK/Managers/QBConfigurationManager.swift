//
//  QBConfigurationManager.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBConfigurationManagerDelegate: class {
    func configurationUpdated()
}

class QBConfigurationManager {
    // MARK: - Private properties
    let trackingId: String
    weak var delegate: QBConfigurationManagerDelegate?
    var configuration: QBConfigurationEntity {
        if let remoteConfiguration = self.remoteConfiguration {
            QBLog.verbose("used remote configuration")
            return remoteConfiguration
        }
        
        if let lastSavedRemoteConfiguration = UserDefaults.standard.lastSavedRemoteConfiguration {
            QBLog.verbose("used last saved remote configuration")
            return lastSavedRemoteConfiguration
        }
        
        QBLog.error("used default configuration")
        return QBConfigurationEntity()
    }
    
    // MARK: - Internal properties
    private var isConfigurationLoaded: Bool {
        return self.remoteConfiguration != nil || UserDefaults.standard.lastSavedRemoteConfiguration != nil
    }

    // MARK: - Private functions
    private var remoteConfiguration: QBConfigurationEntity? = nil {
        didSet {
            UserDefaults.standard.lastSavedRemoteConfiguration = self.remoteConfiguration
            self.lastUpdateTimeStamp = NSDate().timeIntervalSince1970
            self.startTimer()
        }
    }
    private var timer: Timer?
    private var lastUpdateTimeStamp: Double {
        didSet {
            QBLog.verbose("configuration lastUpdateTimeStamp updated = \(lastUpdateTimeStamp)")
        }
    }
    
    private func downloadConfig() {
        QBLog.mark()
        let service = QBConfigurationServiceImp(withTrackingId: self.trackingId)
        service.getConfigution { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let config):
                QBLog.debug("userDefaults = \(UserDefaults.standard.lastSavedRemoteConfiguration.debugDescription)")
                
                strongSelf.remoteConfiguration = config
            case .failure(let error):
                QBLog.error("error = \(error)")
                strongSelf.startTimer()
            }
            if strongSelf.isConfigurationLoaded {
                strongSelf.delegate?.configurationUpdated()
            }
        }
    }
    
    private func shouldUpdateConfiguration() -> Bool {
        let timestamp = NSDate().timeIntervalSince1970
        QBLog.verbose("current timestamp = \(timestamp), last update timestamp = \(lastUpdateTimeStamp), diff = \(timestamp - lastUpdateTimeStamp)")
        if timestamp > lastUpdateTimeStamp + self.configuration.configurationReloadIntervalInSeconds() {
            return true
        }
        return false
    }
    
    // MARK: - Internal functions
    init(withTrackingId trackingId: String, withDeleagte delegate: QBConfigurationManagerDelegate) {
        self.trackingId = trackingId
        self.delegate = delegate
        self.lastUpdateTimeStamp = 0
        downloadConfig()
    }
    
    func getEventsEndpoint() -> URL? {
        var url = self.configuration.mainEndpointUrl()
        url?.appendPathComponent("events/raw")
        url?.appendPathComponent(self.trackingId)
        return url
    }
    
    func getEventsDedupeEndpoint() -> URL? {
        var url = self.configuration.mainEndpointUrl()
        url?.appendPathComponent("events/raw")
        url?.appendPathComponent("\(self.trackingId)?dedupe=true")
        return url
    }
}

// MARK: - Timer
extension QBConfigurationManager {
    private func startTimer() {
        self.stopTimer()
        let reloadInterval = self.configuration.configurationReloadIntervalInSeconds()
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
        QBLog.verbose("⏰ timer tick")
        if self.shouldUpdateConfiguration() {
            QBLog.debug("Config is outdated")
            self.downloadConfig()
        } else {
            QBLog.debug("Config is actual")
        }
    }
}
