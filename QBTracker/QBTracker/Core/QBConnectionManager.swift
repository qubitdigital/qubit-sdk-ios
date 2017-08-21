//
//  QBConnectionManager.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

@objc public class QBConnectionManager: NSObject {
    public let shared = QBConnectionManager()
    
    private var reach: QBReachability?
    
    private override init() {
        super.init()
        
        reach = QBReachability()
        
        reach?.whenReachable = { (reachability) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CONNECTION_CHANGED_VALID_NOTIFICATION_KEY"), object: nil)
        }
        
        reach?.whenUnreachable = { (reachability) in
            print("UNREACHABLE!")
        }
        
        try? reach?.startNotifier()
    }
    
    public func checkConnection() -> Bool {
        let networkReachability = QBReachability()
        let  networkStatus = networkReachability?.currentReachabilityStatus
        
        if networkStatus == .notReachable {
            return false
        }
        
        return true
    }
}
