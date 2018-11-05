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
        case experiences = "ExperiencesDispatchQueue"
        
        func queue() -> DispatchQueue {
            switch self {
            case .qubit:
                return QBDispatchQueueService.backgroundQubitDispatchQueue
            case .coredata:
                return QBDispatchQueueService.backgroundCoreDataDispatchQueue
            case .upload:
                return QBDispatchQueueService.backgroundEventUploadingDispatchQueue
            case .experiences:
                return QBDispatchQueueService.experiencesDispatchQueue
            }
        }
    }
    
    private static let backgroundEventUploadingDispatchQueue = create(type: .upload)
    private static let backgroundCoreDataDispatchQueue = create(type: .coredata)
    private static let backgroundQubitDispatchQueue = create(type: .qubit)
    private static let experiencesDispatchQueue = create(type: .experiences)
    
    private static func create(type: QBDispatchQueueType) -> DispatchQueue {
        return DispatchQueue(label: type.rawValue, qos: .background, autoreleaseFrequency: .inherit)
    }
    
    static func runAsync(type: QBDispatchQueueType, function: @escaping () -> Void ) { type.queue().async { function() } }
    static func runAsync(type: QBDispatchQueueType, deadline: DispatchTime, function: @escaping () -> Void ) {
        type.queue().asyncAfter(deadline: deadline, execute: { function() })
    }
    
    static func runSync(type: QBDispatchQueueType, function: @escaping () -> Void ) { type.queue().async { function() } }

}
