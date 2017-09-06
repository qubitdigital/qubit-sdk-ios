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
            initTimer()
        }
    }
    var sessionManager: QBSessionManager?
    var lookupManager: QBLookupManager?
    private let sendEventsTimeInterval: TimeInterval = 5.0
    private let fetchLimit: Int = 100

    private var timer: Timer?
    private var databaseManager = QBDatabaseManager()
    private var connectionManager = QBConnectionManager()
    private var backgroundQueue: DispatchQueue?
    
    init() {
        initTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initTimer), name: NSNotification.Name(rawValue: QBConnectionManager.notificationKeyReachable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopTimer), name: NSNotification.Name(rawValue: QBConnectionManager.notificationKeyNotReachable), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Internal
    func queue(event: QBEventEntity) {
        QBLog.mark()
		backgroundQueue?.sync {
			guard let dbEvent = self.databaseManager.insert(entityType: QBEvent.self) else {
				return
			}
			
            dbEvent.data = event.eventData
			dbEvent.type = event.type
            dbEvent.dateAdded = NSDate()
			self.databaseManager.save()
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
    private func initTimer() {
        guard let configurationManager = configurationManager else {
            QBLog.info("Configuration is loading, so timer don't started")
            stopTimer()
            return
        }
        
        if configurationManager.configuration.disabled {
            QBLog.info("Sending events disabled in configuration, so timer don't started")
            stopTimer()
            return
        }
        
        if timer == nil && backgroundQueue == nil {
            stopTimer()
            backgroundQueue = DispatchQueue(label: "EventQueue", qos: .background, attributes: .concurrent)
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: self.sendEventsTimeInterval, target: self, selector: #selector(self.sendEvents), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc
    private func stopTimer() {
        QBLog.verbose("Connection lost.  Stopping timer.")
        backgroundQueue = nil
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
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
        
		backgroundQueue?.sync {
			let currentEventBatch = self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: self.fetchLimit)
            
            if currentEventBatch.isEmpty {
                QBLog.debug("🔶 nothing to sent")
                return
            }
            
			let events = self.convert(events: currentEventBatch)
			
            let eventService = QBEventServiceImp(withConfigurationManager: configurationManager)
            
			eventService.sendEvents(events: events) { [weak self] (result) in
				switch result {
				case .success:
					QBLog.info("✅ Successfully sent events")
					self?.databaseManager.delete(entries: currentEventBatch)
				case .failure(let error):
					QBLog.info("Error sending events \(error.localizedDescription)")
					self?.markFailed(events: currentEventBatch)
				}
			}
		}
	}
    
    private func sendEvent(type: String, data: [AnyHashable : Any]) {
        
    }

    private func convert(events: [QBEvent]) -> [QBEventEntity] {
        let result: [QBEventEntity] = []
        
        let convertedArray = events.flatMap { (event: QBEvent) -> QBEventEntity in
            var eventEntity = QBEventEntity(type: event.type!, eventData: event.data!)
            
            let context = QBContextEntity(id: QBDevice.getId(), sample: String(QBDevice.getId().hashValue), viewNumber: 1, sessionNumber: 1, sessionViewNumber: 1, conversionNumber: 2, conversionCycleNumber: 2, lifetimeValue: 2730, lifetimeCurrency: "USD", timeZoneOffset: 1000, viewTs: 1231312312, sessionTs: 1231312312)
            let meta = QBMetaEntity(id: NSUUID().uuidString, ts: Int(Date().timeIntervalSince1970), trackingId: "miquido", type: "ecView", source: "iOS@0.3.1", seq: 3, batchTs: 6)
            eventEntity.meta = meta
            eventEntity.context = context
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
}
