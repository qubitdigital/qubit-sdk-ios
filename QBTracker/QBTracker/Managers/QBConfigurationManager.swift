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
    static let shared = QBConfigurationManager()
    var currentConfiguration: QBConfigurationEntity? = nil
    
    // MARK: Private
    private var timestamp:Int = 0
    private var timer: Timer?
    private var lastUpdateTimeStamp: Double {
        didSet {
            print("lastUpdateTimeStamp updated = \(lastUpdateTimeStamp) \n")
        }
    }

    private init() {
        self.lastUpdateTimeStamp = 0
//        [self loadVisitorId];
        downloadConfig()
//        [self updateFromDictionary:nil];
    }
    
    private func downloadConfig() {
        print("downloadConfig() \n")
        defaultConfigurationService.getConfigution(forId: "roeld") { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let config):
                print("config = \(config) \n")
                
                strongSelf.currentConfiguration = config
                strongSelf.lastUpdateTimeStamp = NSDate().timeIntervalSince1970
                
                if let timer = strongSelf.timer, timer.isValid {
                    return
                }
                
                strongSelf.startTimer()
            case .failure(let error):
                print("error = \(error) \n")
            }
        }
    }
    
    private func shouldUpdateConfiguration() -> Bool {
        let timestamp = NSDate().timeIntervalSince1970
        print("current timestamp = \(timestamp), last update timestamp = \(lastUpdateTimeStamp), diff = \(timestamp - lastUpdateTimeStamp) \n")
        if (timestamp > lastUpdateTimeStamp + QBConfigurationEntity.getReleoadIntervalInSeconds(from: self.currentConfiguration)) {
            return true
        }
        return false;
    }

}

// MARK: - Timer
extension QBConfigurationManager {
    private func startTimer() {
        self.stopTimer()
        let reloadInterval = QBConfigurationEntity.getReleoadIntervalInSeconds(from: self.currentConfiguration)
        guard reloadInterval > 0 else {
            return
        }
        
        DispatchQueue.main.async {
            print("🚀 startTimer \n")
            self.timer = Timer.scheduledTimer(timeInterval: reloadInterval, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        print("🛑 stopTimer \n")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timerTick() {
        print("⏰ timer tick \n")
        if (self.shouldUpdateConfiguration()) {
            print(" Config is outdated \n")
            self.downloadConfig()
        } else {
            print("Config is actual \n")
        }
    }
}
