//
//  QBQueuePriority.swift
//  QubitSDK
//
//  Created by Mateusz Madej on 18/01/2023.
//  Copyright © 2023 Qubit. All rights reserved.
//

import Foundation

@objc
public enum QBQueuePriority: Int {
    case background
    case utility
    case `default`
    case userInitiated
    case userInteractive
}

extension QBQueuePriority {
    var qos: DispatchQoS {
        switch self {
        case .background:
            return .background
        case .utility:
            return .utility
        case .`default`:
            return .`default`
        case .userInitiated:
            return .userInitiated
        case .userInteractive:
            return .userInteractive
        }
    }
}
