//
//  QBDispatchQueueService.swift
//  QubitSDK
//
//  Created by Jacek Grygiel on 14/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

enum QBDispatchQueueService {
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
    
    private static var backgroundEventUploadingDispatchQueue = create(type: .upload)
    private static var backgroundCoreDataDispatchQueue = create(type: .coredata)
    private static var backgroundQubitDispatchQueue = create(type: .qubit)
    
    static func setupQueuePriority(qos: DispatchQoS) {
        backgroundEventUploadingDispatchQueue = create(type: .upload, qos: qos)
        backgroundCoreDataDispatchQueue = create(type: .coredata, qos: qos)
        backgroundQubitDispatchQueue = create(type: .qubit, qos: qos)
    }
    
    private static func create(type: QBDispatchQueueType, qos: DispatchQoS = .background) -> DispatchQueue {
        return DispatchQueue(label: type.rawValue, qos: qos, autoreleaseFrequency: .inherit)
    }
    
    static func runAsync(type: QBDispatchQueueType, function: @escaping () -> Void ) { type.queue().async { function() } }
    static func runAsync(type: QBDispatchQueueType, deadline: DispatchTime, function: @escaping () -> Void ) {
        type.queue().asyncAfter(deadline: deadline, execute: { function() })
    }
    
    static func runSync(type: QBDispatchQueueType, function: @escaping () -> Void ) { type.queue().async { function() } }

}
