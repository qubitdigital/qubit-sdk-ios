//
//  QBEventManager.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class QBEventManager {
    var configurationManager: QBConfigurationManager? {
        didSet {
            startEventManager()
        }
    }

    private var sendingAttemptsDoneCount = 0
    private var sendTimeFrameInterval: Int = 500
    private let batchIntervalMs: Int = 500
    private let expBackoffBaseTimeSec: Int = 5
    private let expBackoffMaxSendingAttempts: Int = 7
    private let maxRetryIntervalSec: Int = 60 * 5
    private let fetchLimit: Int = 15
    private var isSendingEvents: Bool = false
    private var databaseManager = QBDatabaseManager()
    private var connectionManager = QBConnectionManager()
    private var backgroundUploadQueue: DispatchQueue?
    private var backgroundCoreDataQueue: DispatchQueue?

    init() {
        startEventManager()
        NotificationCenter.default.addObserver(self, selector: #selector(self.startEventManager), name: NSNotification.Name(rawValue: QBConnectionManager.notificationKeyReachable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopEventManager), name: NSNotification.Name(rawValue: QBConnectionManager.notificationKeyNotReachable), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Internal
    func addEventInQueue(event: QBEventEntity) {
        QBLog.mark()
		backgroundCoreDataQueue?.sync { [weak self] in
			guard var dbEvent = self?.databaseManager.insert(entityType: QBEvent.self),
                  var dbContext = self?.databaseManager.insert(entityType: QBContextEvent.self),
                  var dbMeta = self?.databaseManager.insert(entityType: QBMetaEvent.self)
                else {
				return
			}
        
            dbEvent = event.fillQBEvent(event: &dbEvent, context: &dbContext, meta: &dbMeta)
            
			self?.databaseManager.save()
            self?.trySendEventsWhenFirstEventAdded()
		}
    }
    
    func sendSessionEvent(start: TimeInterval, end: TimeInterval) {
        var params: [String : Any] = ["ipAddress": "",
                                      "deviceType": "mobile",
                                      "osName": "iOS",
                                      "osVersion": UIDevice.current.systemVersion,
                                      "appType": "app"]
        if start != 0 {
            params["firstViewTs"] = start * 1000
        }
        
        if end != 0 {
            params["lastViewTs"] = end * 1000
        }

        sendEvent(type: "session", data: params)
    }
    
    // MARK: - Private
    @objc
    private func startEventManager() {
        guard let configurationManager = configurationManager else {
            QBLog.info("Configuration is loading, so timer don't started")
            stopEventManager()
            return
        }
        
        if configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration, so timer don't started")
            stopEventManager()
            return
        }
        
        backgroundUploadQueue = DispatchQueue(label: "EventUploadingQueue", qos: .background, attributes: .concurrent)
        backgroundCoreDataQueue = DispatchQueue(label: "EventCoreDataQueue", qos: .background, attributes: .concurrent)
        trySendEvents()
    }
    
    @objc
    private func stopEventManager() {
        QBLog.verbose("Connection lost.  Stopping timer.")
        backgroundUploadQueue = nil
        backgroundCoreDataQueue = nil
    }
    
    @objc
    private func trySendEvents() {
        backgroundCoreDataQueue?.sync { [weak self] in
            guard let fetchLimit = self?.fetchLimit, let sendTimeFrameInterval = self?.sendTimeFrameInterval else { return }
            let deadlineTime = DispatchTime.now() + .milliseconds(sendTimeFrameInterval)
            self?.backgroundUploadQueue?.asyncAfter(deadline: deadlineTime) {
                if ((self?.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: fetchLimit).first) != nil) {
                    self?.sendEvents()
                }
            }
        }
    }
    
    @objc
    private func trySendEventsWhenFirstEventAdded() {
        if self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: fetchLimit).count == 1, self.isSendingEvents == false {
            self.trySendEvents()
        }
    }
    
    @objc
	private func sendEvents() {
        guard let configurationManager = configurationManager else {
            QBLog.info("Configuration is loading, so events will be send after load config")
            return
        }
        
        if configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration")
            return
        }
        
		backgroundUploadQueue?.sync {
			let currentEventBatch = self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: self.fetchLimit)
            
            if currentEventBatch.isEmpty {
                QBLog.debug("🔶 nothing to sent")
                return
            }
            
			let events = self.convert(events: currentEventBatch)
			
            let eventService = QBEventServiceImp(withConfigurationManager: configurationManager)
            
            self.isSendingEvents = true
			eventService.sendEvents(events: events) { [weak self] (result) in
                guard let strongSelf = self else { return }
				switch result {
				case .success:
					QBLog.info("✅ Successfully sent events")
					strongSelf.databaseManager.delete(entries: currentEventBatch)
                    strongSelf.sendTimeFrameInterval = strongSelf.batchIntervalMs
                    strongSelf.sendingAttemptsDoneCount = 0
				case .failure(let error):
					QBLog.info("Error sending events \(error.localizedDescription)")
					strongSelf.markFailed(events: currentEventBatch)
                    strongSelf.sendingAttemptsDoneCount += 1
                    strongSelf.sendTimeFrameInterval = strongSelf.evaluateIntervalMsToNextRetry(sendingAttemptsDone: strongSelf.sendingAttemptsDoneCount)
				}
                strongSelf.isSendingEvents = false
                strongSelf.trySendEvents()
			}
		}
	}
    
    private func sendEvent(type: String, data: [AnyHashable : Any]) {
        
    }

    private func convert(events: [QBEvent]) -> [QBEventEntity] {
        
        let convertedArray = events.flatMap { (event: QBEvent) -> QBEventEntity? in
            let eventEntity = QBEventEntity.create(with: event)
            return eventEntity
        }
        
        return convertedArray
    }
    
    private func markFailed(events: [QBEvent]) {
        events.forEach { (event) in
            event.sendFailed = true
        }
        
        databaseManager.save()
    }
    
    private func evaluateIntervalMsToNextRetry(sendingAttemptsDone: Int) -> Int {
        if sendingAttemptsDone > expBackoffMaxSendingAttempts {
            let seconds = TimeInterval(maxRetryIntervalSec)
            return seconds.millisecond
        } else {
            let maxSecs: Int = 2 ^ (sendingAttemptsDone - 1) * expBackoffBaseTimeSec
            return Int(max(arc4random_uniform(UInt32(maxSecs))+1, UInt32(maxRetryIntervalSec)))
        }
    }
}
