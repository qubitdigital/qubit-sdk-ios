//
//  QBTracker+Adapter.swift
//  QubitSDK
//
//  Created by Jacek Grygiel on 18/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import UIKit

@objc
public class QBTrackerInit: NSObject {
    
    static let sharedInstance: QBTrackerInit = QBTrackerInit()
    
    func applicationDidFinishLaunching() {
        
    }
    
    func applicationEnterForeground() {
        
    }
    
    func initConfig(fromForeground:Bool, completion: (() -> Void)?) {
        
    }
    
    func invalidateConfigTimer() {
        
    }
    
    func validateConfigTimer() {
        
    }
}


@objc
public class QBTrackerManager: NSObject {
    
    public static let sharedManager: QBTrackerManager = QBTrackerManager()
    
    @objc
    public func setTrackingId(trackingId: String) {
        
    }

    @objc
    public func setDebugEndpoint(endPointUrl: String) {
        
    }
    @objc
    public func unsubscribeToTracking() {
        
    }
    
    @objc
    public func subscribeToTracking() {
        
    }
    
    @objc
    public func dispatchEvent(type: String, withData: [String: Any]) {
        
    }
    
    @objc
    public func dispatchEvent(type: String, withStringData: String) {
        
    }
    
    @objc
    public func dispatchSessionEvent(startTimeStamp: TimeInterval, withEnd: TimeInterval) {
        
    }
    
    @objc
    public func getUserID() -> String {
        return ""
    }
    
    @objc
    public func setStashInfo(data: String, key: String, withCallback: (Int) -> Void) {
        
    }
    
    @objc
    public func setStashInfo(key: String, withCallback: (Int,String) -> Void) {
        
    }
    
    @objc
    public func setStashInfoMultiple(userkeys:[String], withCallback: (Int,[String: Any]) -> Void) {
        
    }

    @objc
    public func getSegmentMemrshipInfo(userId: String, withCallback: (Int, [String]) -> Void) {
        
    }

}

public let qubit: QBTrackerManager = QBTrackerManager()
