//
//  QBEventService.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBEventRepository {
    func sendEvent(withString string: String, completion: ((Result<QBStatusEntity>) -> Void)?)
    func sendEvents(events: [QBEventEntity], completion: ((Result<QBStatusEntity>) -> Void)?)
}

protocol QBEventService {
    func sendEvent(withString string: String, completion: ((Result<QBStatusEntity>) -> Void)?)
    func sendEvents(events: [QBEventEntity], completion: ((Result<QBStatusEntity>) -> Void)?)
}

class QBEventServiceImp: QBEventService {
    fileprivate let repository: QBEventRepository
    
    init(repository: QBEventRepository) {
        self.repository = repository
    }
    
    func sendEvent(withString string: String, completion: ((Result<QBStatusEntity>) -> Void)?) {
        repository.sendEvent(withString: string, completion: completion)
    }
    
    func sendEvents(events: [QBEventEntity], completion: ((Result<QBStatusEntity>) -> Void)?) {
        
    }
}

let defaultEventService: QBEventService = QBEventServiceImp(
    repository: QBEventRepositoryImp()
)
