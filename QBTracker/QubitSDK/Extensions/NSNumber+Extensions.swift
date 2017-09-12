//
//  NSNumber+Extensions.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 12/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension NSNumber {
    static func getOptionalNumber(fromInt int: Int?) -> NSNumber? {
        if let value = int {
            return NSNumber(value: value)
        }
        return nil
    }
    
    static func getOptionalNumber(fromDouble double: Double?) -> NSNumber? {
        if let value = double {
            return NSNumber(value: value)
        }
        return nil
    }

}
