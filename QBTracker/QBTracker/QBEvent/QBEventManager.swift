//
//  QBEventManager.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBEventManager {
    
    private let sendEventsTimeInterval: TimeInterval = 1.0
    private var timer: Timer?
    
    private var databaseManager = QBDatabaseManager.shared
    private var connectionManager = QBConnectionManager.shared
    
    private let lock = NSLock()
    
    init() {
        initTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.initTimer), name: NSNotification.Name(rawValue: "CONNECTION_CHANGED_REACHABLE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopTimer), name: NSNotification.Name(rawValue: "CONNECTION_CHANGED_NOT_REACHABLE"), object: nil)
    }
    
    @objc
    private func initTimer() {
        stopTimer()
//        DispatchQueue.main.async {
//            self.timer = Timer.scheduledTimer(timeInterval: self.sendEventsTimeInterval, target: self, selector: #selector(self.sendEvents), userInfo: nil, repeats: true)
//        }
    }
    
    @objc
    private func stopTimer() {
        QBLog.verbose("Connection lost.  Stopping timer.")
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func queue(event: QBEventEntity) {
        guard let dbEvent = databaseManager.insert(entityType: QBEvent.self) else {
            return
        }
        
        dbEvent.dateAdded = Date()
        databaseManager.save()
    }
    
//    @objc
//    private func sendEvents() {
//        lock.lock()
//        let currentEventBatch = databaseManager.query(entityType: QBEvent.self)
//        let events = convert(events: currentEventBatch)
//        
//        defaultEventService.sendEvents(events: events) { [weak self] (result) in
//            switch result {
//            case .success:
//                QBLog.info("Successfully sent events")
//                self?.databaseManager.delete(entries: currentEventBatch)
//            case .failure(let error):
//                QBLog.info("Error sending events \(error.localizedDescription)")
//                self?.markFailed(events: currentEventBatch)
//            }
//            self?.lock.unlock()
//        }
//    }
//
//    private func convert(events: [QBEvent]) -> [QBEventEntity] {
//        let result: [QBEventEntity] = []
//        
//        return result
//    }
//    
//    private func markFailed(events: [QBEvent]) {
//        events.forEach { (event) in
////            event.sendFailed = true
//        }
//        
//        databaseManager.save()
//    }
}
