//
//  NSDate+Extensions.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 08/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension Date {
    var timeIntervalSince1970InMs: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
