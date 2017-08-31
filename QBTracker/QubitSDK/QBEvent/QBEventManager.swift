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
    
    private let sendEventsTimeInterval: TimeInterval = 1.0
    private var timer: Timer?
    
    private var databaseManager = QBDatabaseManager.shared
    private var connectionManager = QBConnectionManager.shared
    private let fetchLimit: Int = 15

	private var backgroundQueue: DispatchQueue?
    
    init() {
        initTimer()
        
        //TODO: Change magic strings to Constants
        NotificationCenter.default.addObserver(self, selector: #selector(self.initTimer), name: NSNotification.Name(rawValue: "CONNECTION_CHANGED_REACHABLE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopTimer), name: NSNotification.Name(rawValue: "CONNECTION_CHANGED_NOT_REACHABLE"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func initTimer() {
        stopTimer()
		backgroundQueue = DispatchQueue(label: "EventQueue", qos: .background, attributes: .concurrent)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: self.sendEventsTimeInterval, target: self, selector: #selector(self.sendEvents), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    private func stopTimer() {
        //TODO: should also be called when configuration flag (disabled) is true
        QBLog.verbose("Connection lost.  Stopping timer.")
		backgroundQueue = nil
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func queue(event: QBEventEntity) {
		backgroundQueue?.sync {
			guard let dbEvent = self.databaseManager.insert(entityType: QBEvent.self) else {
				return
			}
			
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
    
    @objc
	private func sendEvents() {
		backgroundQueue?.sync {
			let currentEventBatch = self.databaseManager.query(entityType: QBEvent.self, sortBy: "dateAdded", ascending: true, limit: self.fetchLimit)
			let events = self.convert(events: currentEventBatch)
			
			defaultEventService.sendEvents(events: events) { [weak self] (result) in
				switch result {
				case .success:
					QBLog.info("Successfully sent events")
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
        
        return result
    }
    
    private func markFailed(events: [QBEvent]) {
        events.forEach { (event) in
            event.sendFailed = true
        }
        
        databaseManager.save()
    }
}
