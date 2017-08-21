//
//  QBConnectionManager.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBConnectionManager: NSObject {
    static let shared = QBConnectionManager()
    
    private var reachability: QBReachability?
    
    private override init() {
        super.init()
        
        reachability = QBReachability()
        
        reachability?.whenReachable = { (reachability) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CONNECTION_CHANGED_VALID_NOTIFICATION_KEY"), object: nil)
        }
        
        reachability?.whenUnreachable = { (reachability) in
            print("UNREACHABLE!")
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Error starting reachability notifier.")
        }
    }
    
    func checkConnection() -> Bool {
        let networkReachability = QBReachability()
        let  networkStatus = networkReachability?.currentReachabilityStatus
        
        return networkStatus != .notReachable
    }
}
