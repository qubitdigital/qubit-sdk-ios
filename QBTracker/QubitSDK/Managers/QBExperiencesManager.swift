//
//  QBExperiencesManager.swift
//  QubitSDK
//
//  Created by Andrzej Zuzak on 30/10/2018.
//  Copyright © 2018 Qubit. All rights reserved.
//

import Foundation

class QBExperiencesManager {
    
    var cachedExperiences: [QBExperienceEntity]? {
        get {
            if let lastSavedRemoteExperiences = UserDefaults.standard.lastSavedRemoteExperiences {
                QBLog.verbose("used last saved remote experiences")
                return lastSavedRemoteExperiences
            }
            
            return nil
        }
        
        set {
            UserDefaults.standard.lastSavedRemoteExperiences = newValue
            UserDefaults.standard.lastExperienceCacheTime = NSDate().timeIntervalSince1970
            self.startTimer()
        }
    }
    
    var downloadParams: (preview: Bool, ignoreSegments: Bool, variation: Int?) = (false, false, nil)
    
    private var timer: Timer?
    private let configurationManager: QBConfigurationManager
    private var reachability = QBReachability()
    private let experiencesService: QBExperiencesService
    
    init(configurationManager: QBConfigurationManager) {
        self.configurationManager = configurationManager
        self.experiencesService = QBExperiencesServiceImp(withConfigurationManager: self.configurationManager)
        try? reachability?.startNotifier()
    }
    
    internal func configurationUpdated() {
        refreshCacheIfNeede()
    }
    
    internal func fetchExperiences(with ids: [Int],
                                   completion: @escaping ([QBExperienceEntity]?, Error?) -> Void) {
        let shouldBypassCache = (downloadParams.preview || downloadParams.ignoreSegments || downloadParams.variation != nil)
        let shouldDownloadExperiences = (shouldBypassCache || shouldRefreshExperiencesCache)
        
        if shouldDownloadExperiences {
            QBLog.info("Downloading experiences")
            
            downloadExperiences { [weak self] (experiences, error) in
                if let experiences = experiences {
                    completion(self?.getFilteredExperiences(experiences, by: ids), nil)
                } else if let error = error {
                    completion(nil, error)
                }
            }
        } else if let cachedExperiences = cachedExperiences {
            QBLog.info("Using cached experiences")
            completion(getFilteredExperiences(cachedExperiences, by: ids), nil)
        } else {
            QBLog.error("There was a problem while retrieving experiences")
        }
    }
    
    private func getFilteredExperiences(_ experiences: [QBExperienceEntity], by ids: [Int]) -> [QBExperienceEntity] {
        return ids.isEmpty ? experiences : experiences.filter { ids.contains($0.experienceId) }
    }
    
    private func downloadExperiences(completion: @escaping ([QBExperienceEntity]?, Error?) -> Void) {
        QBLog.mark()
        
        guard configurationManager.isConfigurationLoaded else {
            QBLog.info("Configuration is loading, so experiences will be loaded afterwards")
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
        
        experiencesService.getExperiences(forDeviceId: QBDevice.getId(),
                                          preview: downloadParams.preview,
                                          ignoreSegments: downloadParams.ignoreSegments,
                                          variation: downloadParams.variation) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let experiences):
                self.cachedExperiences = experiences.experiencePayloads
                completion(experiences.experiencePayloads, nil)
                QBLog.debug("userDefaults = \(UserDefaults.standard.lastSavedRemoteExperiences.debugDescription)")
            case .failure(let error):
                completion(nil, error)
                QBLog.error("error = \(error)")
            }
        }
    }
    
    private var shouldRefreshExperiencesCache: Bool {
        guard let lastUpdateTimeStamp = UserDefaults.standard.lastExperienceCacheTime,
              self.cachedExperiences != nil else {
            return true
        }
        
        let timestamp = NSDate().timeIntervalSince1970
        QBLog.verbose("experiences current timestamp = \(timestamp), last update timestamp = \(lastUpdateTimeStamp), diff = \(timestamp - lastUpdateTimeStamp)")
        
        let experienceCacheTimeout = Double(self.configurationManager.configuration.experienceCacheTimeout)
        if timestamp > lastUpdateTimeStamp + experienceCacheTimeout {
            return true
        }
        
        return false
    }
    
    private func refreshCacheIfNeede() {
        if self.shouldRefreshExperiencesCache {
            QBLog.debug("Experiences are outdated")
            
            self.downloadExperiences { (experiences, error) in
                if experiences != nil {
                    QBLog.info("Experiences cache refreshed")
                }
                
                if let error = error {
                    QBLog.error("Error while refreshing experiences cache: \(error)")
                }
            }
        } else {
            QBLog.debug("Experience cache is actual")
        }
    }
}

// MARK: - Timer

extension QBExperiencesManager {
    
    private func startTimer() {
        self.stopTimer()
        let reloadInterval = self.configurationManager.configuration.experienceCacheTimeout
        
        guard reloadInterval > 0 else {
            return
        }
        
        DispatchQueue.main.async {
            QBLog.verbose("🚀 startTimer")
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(reloadInterval), target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
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
        QBLog.verbose("⏰ experience timer tick")
        
        if self.shouldRefreshExperiencesCache {
            QBLog.debug("Experiences are outdated")
            
            self.downloadExperiences { (experiences, error) in
                if experiences != nil {
                    QBLog.info("Experiences cache refreshed")
                }
                
                if let error = error {
                   QBLog.error("Error while refreshing experiences cache: \(error)")
                }
            }
        } else {
            QBLog.debug("Experience cache is actual")
        }
    }
}

