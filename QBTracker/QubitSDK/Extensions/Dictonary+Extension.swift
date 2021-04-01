//
//  Dictonary+Extension.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 12/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension Dictionary {
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        for (key, value) in rhs {
            lhs[key] = value
        }
    }

    static func + (left: Dictionary, right: Dictionary) -> Dictionary {
        var map = Dictionary()
        for (k, v) in left {
            map[k] = v
        }
        for (k, v) in right {
            map[k] = v
        }
        return map
    }

    var jsonString: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []), let string = String(data: data, encoding: .utf8) else {
            return ""
        }
        return string
    }

}
