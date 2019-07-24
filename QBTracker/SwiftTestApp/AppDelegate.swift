//
//  AppDelegate.swift
//  SwiftTestApp
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import UIKit
import QubitSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        QubitSDK.start(withTrackingId: "miquido", logLevel: .verbose)
        return true
    }
	
}
