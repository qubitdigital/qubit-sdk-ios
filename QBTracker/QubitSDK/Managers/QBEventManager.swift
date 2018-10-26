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

struct QBEventManagerConfig {
    var sendingAttemptsDoneCount = 0
    var dedupeActive: Bool = false
    var sendTimeFrameInterval: Int = 500
    let batchIntervalMs: Int = 500
    let expBackoffBaseTimeSec: Int = 5
    let expBackoffMaxSendingAttempts: Int = 7
    let maxRetryIntervalSec: Int = 60 * 5
    let oneEventCount = 1
    let fetchLimit: Int = 15
    
    mutating func reset() {
        sendTimeFrameInterval = batchIntervalMs
        sendingAttemptsDoneCount = 0
        dedupeActive = false
    }
    
    mutating func increaseRetry(sendTimeInterval: Int, addDedupe: Bool) {
        sendTimeFrameInterval = sendTimeInterval
        sendingAttemptsDoneCount += 1
        dedupeActive = addDedupe
    }
}

class QBEventManager {
    private var isSendingEvents: Bool = false
    private var isEnabled: Bool = false
    private var hasStopped: Bool = false

    private var config: QBEventManagerConfig = QBEventManagerConfig()
    private var databaseManager = QBDatabaseManager()
    
    private let configurationManager: QBConfigurationManager
    private let sessionManager: QBSessionManager
    private let lookupManager: QBLookupManager
    private var reachability = QBReachability()
    
    init(withConfigurationManager configurationManager: QBConfigurationManager, sessionManager: QBSessionManager, lookupManager: QBLookupManager) {
        self.configurationManager = configurationManager
        self.sessionManager = sessionManager
        self.lookupManager = lookupManager
        try? reachability?.startNotifier()
        
        reachability?.whenReachable = { [weak self] (reachability) in
            guard let `self` = self else { return }
            if self.hasStopped == true { self.startEventManager() }
        }
        reachability?.whenUnreachable = { [weak self] (reachability) in
            guard let `self` = self else { return }
            self.stopEventManager()
        }
    }
    
    deinit {
        self.isEnabled = false
    }
    
    // MARK: - Internal
    
    static func createEvent(type: String, dictionary: [String: Any]) -> QBEventEntity? {
        return QBEventEntity.event(type: type, dictionary: dictionary)
    }
    
    static func createEvent(type: String, data: String) -> QBEventEntity? {
        return QBEventEntity.event(type: type, string: data)
    }
    
    func sendSessionEvent() {
        QBLog.mark()
        let deviceInfo = sessionManager.session.deviceInfo
        let session = QBSessionEntity(firstViewTs: lookupManager.lookup?.firstViewTs,
                                      lastViewTs: lookupManager.lookup?.lastViewTs,
                                      firstConversionTs: lookupManager.lookup?.firstConversionTs,
                                      lastConversionTs: lookupManager.lookup?.lastConversionTs,
                                      ipLocation: lookupManager.lookup?.ipLocation,
                                      ipAddress: lookupManager.lookup?.ipAddress,
                                      deviceType: deviceInfo.deviceType,
                                      deviceName: deviceInfo.deviceName,
                                      osName: deviceInfo.osName,
                                      osVersion: deviceInfo.osVersion,
                                      appType: deviceInfo.appType.rawValue,
                                      appName: deviceInfo.appName,
                                      appVersion: deviceInfo.appVersion,
                                      screenWidth: deviceInfo.screenWidth,
                                      screenHeight: deviceInfo.screenHeight)
        
        let event = QBEventEntity(type: "qubit.session", eventData: "", session: session)
        self.sendEvent(event: event)
    }
    
    func sendEvent(event: QBEventEntity) {        
        if configurationManager.isConfigurationLoaded && configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration")
            return
        }
        
        let timestampInMs = Date().timeIntervalSince1970InMs
        sessionManager.eventAdded(type: event.enumType, timestampInMS: timestampInMs)
        let context = QBContextEntity(withSession: sessionManager.session, lookup: lookupManager.lookup)
        // TODO: fill batchTs
        let meta = QBMetaEntity(id: NSUUID().uuidString, ts: timestampInMs, trackingId: self.configurationManager.trackingId, type: event.type, source: sessionManager.session.deviceInfo.getOsNameAndVersion(), seq: sessionManager.session.sequenceEventNumber, batchTs: 123)
        
        var event = event
        event.add(context: context, meta: meta)
        self.addEventInQueue(event: event)
    }
    
    func configurationUpdated() {
        startEventManager()
    }
    
    private func addEventInQueue(event: QBEventEntity) {
        QBLog.mark()
        
        QBDispatchQueueService.runSync(type: .coredata) { [weak self] in
            self?.databaseManager.database?.managedObjectContext.performAndWait {
                guard var dbEvent = self?.databaseManager.insert(entityType: QBEvent.self),
                    var dbContext = self?.databaseManager.insert(entityType: QBContextEvent.self),
                    var dbMeta = self?.databaseManager.insert(entityType: QBMetaEvent.self),
                    var dbSession = self?.databaseManager.insert(entityType: QBSessionEvent.self)
                    else {
                        return
                }
                
                dbEvent = event.fillQBEvent(event: &dbEvent, context: &dbContext, meta: &dbMeta, session: &dbSession)
                
                self?.databaseManager.save()
                self?.trySendEventsWhenFirstEventAdded()
            }
        }
    }
    
    // MARK: - Private
    private func startEventManager() {
        QBDispatchQueueService.runSync(type: .qubit) { [weak self] in
            guard let `self` = self else { return }
            guard self.configurationManager.isConfigurationLoaded else {
                QBLog.info("Configuration is loading, so timer don't started")
                self.stopEventManager()
                return
            }
            
            if self.configurationManager.configuration.disabled {
                QBLog.info("Sending events disabled in configuration, so timer don't started")
                self.stopEventManager()
                return
            }
            self.isEnabled = true
            self.tryRemoveOldEvents()
            self.tryRemoveFailedEvents()
            self.trySendEvents()
        }
    }
    
    private func stopEventManager() {
        QBDispatchQueueService.runSync(type: .qubit) { [weak self] in
            guard let `self` = self else { return }
            self.isEnabled = false
            self.hasStopped = true
            QBLog.verbose("Connection lost.")
        }
    }
    
    @objc
    private func trySendEvents() {
        tryRemoveFailedEvents()
        if isEnabled == false { return }
        
            let fetchLimit = self.config.fetchLimit
            let sendTimeFrameInterval = self.config.sendTimeFrameInterval
        
            let deadlineTime = DispatchTime.now() + .milliseconds(sendTimeFrameInterval)
            QBDispatchQueueService.runAsync(type: .upload, deadline: deadlineTime) { [weak self] in
                guard let `self` = self else { return }
                self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: fetchLimit) { results in
                    if !results.isEmpty {
                        QBLog.info("Sending events count -> \(results.count)")
                        self.sendEvents()
                    }
                }
            }
        
    }
    
    @objc
    private func trySendEventsWhenFirstEventAdded() {
        if isEnabled == false { return }
        self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: self.config.fetchLimit) { results in
            if !results.isEmpty && self.isSendingEvents == false {
                self.isSendingEvents = true
                self.trySendEvents()
            }
        }
    }
    
    private func canSendEvents() -> Bool {
        if isEnabled == false { return false }
    
        guard configurationManager.isConfigurationLoaded else {
            QBLog.info("Configuration is loading, so events will be send after load config")
            return false
        }
    
        if configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration")
            return false
        }
    
        if reachability?.isReachable == false {
            QBLog.error("Not connected to the Internet")
            return false
        }
        
        return true
    }
    
    private func sendEvents() {
        guard canSendEvents() else { return }
        QBDispatchQueueService.runSync(type: .upload) { [weak self] in
            
            guard let `self` = self else { return }
            
            self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: self.config.fetchLimit) { [weak self] currentEventBatch in

                guard let `self` = self else { return }
                if currentEventBatch.isEmpty {
                    QBLog.debug("🔶 nothing to sent")
                    return
                }
                
                let events = self.convert(events: currentEventBatch)
                let eventService = QBEventServiceImp(withConfigurationManager: self.configurationManager)
                
                eventService.sendEvents(events: events, dedupe: self.config.dedupeActive) { [weak self] (result) in
                    guard let `self` = self else { return }
                    switch result {
                    case .success:
                        QBLog.info("✅ Successfully sent events")
                        self.databaseManager.delete(entries: currentEventBatch)
                        self.config.reset()
                    case .failure(let error):
                        QBLog.info("⛔️ Error sending events \(error.localizedDescription)")
                        self.markFailed(events: currentEventBatch)
                        self.config.increaseRetry(sendTimeInterval: self.evaluateIntervalMsToNextRetry(sendingAttemptsDone: self.config.sendingAttemptsDoneCount), addDedupe: true)
                    }
                    self.isSendingEvents = false
                    self.trySendEvents()
                }
            }
        }
    }
        
    private func convert(events: [QBEvent]) -> [QBEventEntity] {
        
        let convertedArray = events.compactMap { (event: QBEvent) -> QBEventEntity? in
            let eventEntity = QBEventEntity.create(with: event, configuration: self.configurationManager.configuration)
            return eventEntity
        }
        
        return convertedArray
    }
    
    private func markFailed(events: [QBEvent]) {
        events.forEach { (event) in
            event.sendFailed = true
            event.errorRetryCount = NSNumber(value: (event.errorRetryCount?.intValue ?? 0) + 1)
        }
        
        databaseManager.save()
    }
    
    private func tryRemoveOldEvents() {
        let removeOldEventsTime = self.configurationManager.configuration.queueTimeout
        let predicate = NSPredicate(format: "dateAdded > %@", Date().addingTimeInterval(TimeInterval(-removeOldEventsTime)) as CVarArg)
        self.databaseManager.query(entityType: QBEvent.self, predicate: predicate, ascending: true, limit: 0) { (results) in
            QBLog.info("Remove oldest events from database")
            self.databaseManager.delete(entries: results)
        }
    }
    
    private func tryRemoveFailedEvents() {
        let maxErrorRetryCount = self.configurationManager.maxErrorRetryCount
        let predicate = NSPredicate(format: "errorRetryCount > %d", maxErrorRetryCount)
        self.databaseManager.query(entityType: QBEvent.self, predicate: predicate, ascending: true, limit: 0) { (results) in
            QBLog.info("Remove oldest events from database")
            self.databaseManager.delete(entries: results)
        }
    }
    
    private func evaluateIntervalMsToNextRetry(sendingAttemptsDone: Int) -> Int {
        if sendingAttemptsDone > config.expBackoffMaxSendingAttempts {
            let seconds = TimeInterval(config.maxRetryIntervalSec)
            return seconds.millisecond
        } else {
            let maxSecs: Int = 2 ^ (sendingAttemptsDone) * config.expBackoffBaseTimeSec
            return Int(min(arc4random_uniform(UInt32(maxSecs))+1, UInt32(config.maxRetryIntervalSec)))
        }
    }
}
