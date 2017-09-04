//
//  QBConnectionManager.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBConnectionManager {
    static let notificationKeyReachable = "QBConnectionManagerNotificationKeyReachable"
    static let notificationKeyNotReachable = "QBConnectionManagerNotificationKeyNotReachable"

    private var reachability: QBReachability?
    
    init() {
        reachability = QBReachability()
        
        reachability?.whenReachable = { (reachability) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: QBConnectionManager.notificationKeyReachable), object: nil)
        }
        
        reachability?.whenUnreachable = { (reachability) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: QBConnectionManager.notificationKeyNotReachable), object: nil)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            QBLog.error("Error starting reachability notifier.")
        }
    }
    
    func checkConnection() -> Bool {
        let networkReachability = QBReachability()
        let  networkStatus = networkReachability?.currentReachabilityStatus
        
        return networkStatus != .notReachable
    }
}
