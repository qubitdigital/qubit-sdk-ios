//
//  AppDelegate.swift
//  QubitSwiftFrameworkDebugExampleApp
//
//  Created by Mariusz Jakowienko on 29/07/2020.
//  Copyright © 2020 Mariusz Jakowienko. All rights reserved.
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

