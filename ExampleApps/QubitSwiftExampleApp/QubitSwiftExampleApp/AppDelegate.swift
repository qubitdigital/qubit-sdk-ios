//
//  AppDelegate.swift
//  QubitSwiftExampleApp
//
//  Created by Pavlo Davydiuk on 29/08/2017.
//  Copyright © 2017 Qubiit. All rights reserved.
//

import UIKit
import QubitSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        QubitSDK.start(withTrackingId: "miquido", logLevel: .verbose)
        return true
    }

}
