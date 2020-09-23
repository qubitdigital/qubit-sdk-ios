//
//  QBDeviceInfoEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 07/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import UIKit

struct QBDeviceInfoEntity: Codable {
    enum QBAppType: String, Codable {
        case app
    }
    let deviceType: String
    let deviceName: String
    let osName: String
    let osVersion: String
    let appType = QBAppType.app
    let appName: String
    let appVersion: String
    let screenWidth: Int
    let screenHeight: Int
    
    init() {
        deviceType = QBDeviceInfoEntity.getDeviceType()
        appName = QBDeviceInfoEntity.getApplicationName()
        appVersion = QBDeviceInfoEntity.getApplicationVesion()
        let device = UIDevice.current
        deviceName = QBDeviceInfoEntity.getDeviceModel()
        osName = device.systemName
        osVersion = device.systemVersion

        let screenSize = UIScreen.main.bounds
        screenWidth = Int(screenSize.width)
        screenHeight = Int(screenSize.height)
    }

}

// MARK: - Helpers
extension QBDeviceInfoEntity {
    func getOsNameAndVersion() -> String {
        return osName + "@" + osVersion
    }
    
    private static func getDeviceType() -> String {
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified:
            return "unspecified"
        case .phone:
            return "phone"
        case .pad:
            return "pad"
        case .tv:
            return "tv"
        case .carPlay:
            return "carPlay"
        @unknown default:
            return "unknown"
        }
    }
    
    private static func getApplicationName() -> String {
        guard let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String else {
            return "no application name info"
        }
        return name
    }
    
    private static func getApplicationVesion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "no version info"
        }
        return version
    }
    
    private static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
