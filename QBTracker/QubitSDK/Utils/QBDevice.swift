//
//  QBDevice.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 25/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import UIKit

class QBDevice {
    private static let key = "QUBIT_VISITOR_ID"
    private static let md5_zero = String(0).md5
    
    static func getId() -> String {
        let keychain = QBKeychainSwift()

        if let deviceId = keychain.get(key), !deviceId.isEmpty, deviceId != md5_zero {
            return deviceId
        }

        let md5String = randomStringInMd5()
        keychain.set(md5String, forKey: key)
        return md5String
    }
    
    static func setId(newId: String) {
        let keychain = QBKeychainSwift()
        keychain.set(newId, forKey: key)
    }
    
    private static func randomStringInMd5() -> String {
        let timestamp = NSDate().timeIntervalSince1970
        let randomValue = Int(timestamp) * Int.random(in: 1...1000)
        let md5String = String(randomValue).md5
        return md5String
    }
}
