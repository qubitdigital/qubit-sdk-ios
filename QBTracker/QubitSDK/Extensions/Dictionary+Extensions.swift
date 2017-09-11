//
//  Dictionary+Extensions.swift
//  QubitSDK
//
//  Created by Jacek Grygiel on 10/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension Dictionary where Key: CustomDebugStringConvertible, Value:CustomDebugStringConvertible {
    func prettyPrint() {
        for (key, value) in self {
            print("\(key) = \(value)")
        }
    }
}
