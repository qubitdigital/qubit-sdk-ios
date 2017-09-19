//
//  QBDispatchQueueService.swift
//  QubitSDK
//
//  Created by Jacek Grygiel on 14/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBDispatchQueueService {
    
    enum QBDispatchQueueType: String {
        case qubit = "QubitDispatchQueue"
        case upload = "EventUploadingDispatchQueue"
        case coredata = "CoreDataDispatchQueue"
        
        func queue() -> DispatchQueue {
            switch self {
            case .qubit:
                return QBDispatchQueueService.backgroundQubitDispatchQueue
            case .coredata:
                return QBDispatchQueueService.backgroundCoreDataDispatchQueue
            case .upload:
                return QBDispatchQueueService.backgroundEventUploadingDispatchQueue
            }
        }
    }
    
    private static let backgroundEventUploadingDispatchQueue = create(type: .upload)
    private static let backgroundCoreDataDispatchQueue = create(type: .coredata)
    private static let backgroundQubitDispatchQueue = create(type: .qubit)
    
    private static func create(type: QBDispatchQueueType) -> DispatchQueue {
        return DispatchQueue(label: type.rawValue, qos: .background)
    }
    
    static func runAsync(type: QBDispatchQueueType, function: @escaping () -> Void ) { type.queue().async { function() } }
    static func runAsync(type: QBDispatchQueueType, deadline: DispatchTime, function: @escaping () -> Void ) {
        type.queue().asyncAfter(deadline: deadline, execute: { function() })
    }
    
    static func runSync(type: QBDispatchQueueType, function: @escaping () -> Void ) { type.queue().async { function() } }

}
