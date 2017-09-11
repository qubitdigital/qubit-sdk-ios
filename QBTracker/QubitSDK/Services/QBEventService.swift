//
//  QBEventService.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBEventService {
    func sendEvents(events: [QBEventEntity], dedupe: Bool, completion: ((Result<QBStatusEntity>) -> Void)?)
}

class QBEventServiceImp: QBEventService {
    private let configurationManager: QBConfigurationManager
    private let apiClient: QBAPIClient = {
        return QBAPIClient()
    }()
    
    init(withConfigurationManager configurationManager: QBConfigurationManager) {
        self.configurationManager = configurationManager
    }

    func sendEvents(events: [QBEventEntity], dedupe: Bool, completion: ((Result<QBStatusEntity>) -> Void)?) {
        guard let url = dedupe ? configurationManager.getEventsDedupeEndpoint() : configurationManager.getEventsEndpoint() else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for send events is nil"]) as Error
            QBLog.error("URL for send events is nil")
            completion?(.failure(error))
            assert(false, "URL for send events is nil")
            return
        }
        
        var request = URLRequest(url: url)
        
        let jsonData = try? JSONEncoder().encode(events)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiClient.dataTask(request: request, method: HTTPMethod.post, completion: completion)
    }
}
