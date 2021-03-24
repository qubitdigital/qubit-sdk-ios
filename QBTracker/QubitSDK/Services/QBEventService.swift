//
//  QBEventService.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreFoundation

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
        let batchTs = Int64(Date().timeIntervalSince1970)
        for event in events {
            var event = event
            event.setBatchTs(batchTs: batchTs)
        }
        
        do {
            let jsonData = try JSONEncoder().encode(events)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            apiClient.makeRequestAndDecode(request, withMethod: HTTPMethod.post, then: completion)
        } catch {
            QBLog.error("Error encoding events data into JSON")
            completion?(.failure(error))
            assert(false, "Cannot compose JSON from events")
        }
    }
}
