//
//  Dictonary+Extension.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 12/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension Dictionary {
    static func +=(lhs: inout Dictionary, rhs: Dictionary) {
        for (k, v) in rhs {
            lhs[k] = v
        }
    }
}
