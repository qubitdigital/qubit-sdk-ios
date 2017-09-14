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
    }
    
    static func create(type: QBDispatchQueueType) -> DispatchQueue {
        return DispatchQueue(label: type.rawValue, qos: .background, attributes: .concurrent)
    }
}
