//
//  QBLookupService.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBLookupService {
    func getLookup(forDeviceId id: String, completion: ((Result<QBLookupEntity>) -> ())?)
}

private let apiClient: QBAPIClient = {
    return QBAPIClient()
}()

class QBLookupServiceImp: QBLookupService {
    private let configurationManager: QBConfigurationManager
    private let trackingId: String
    
    init(withConfigurationManager configurationManager: QBConfigurationManager, withTrackingId trackingId: String) {
        self.configurationManager = configurationManager
        self.trackingId = trackingId
    }
    
    func getLookup(forDeviceId id: String, completion: ((Result<QBLookupEntity>) -> ())?) {
        guard let url = configurationManager.configuration.lookupEndpointUrl() else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "URL for lookup is nil"]) as Error
            QBLog.error("URL for lookup is nil")
            completion?(.failure(error))
            return
        }
        
        var urlWithPath = url
        urlWithPath.appendPathComponent(trackingId)
        urlWithPath.appendPathComponent(id)
        
        let request = URLRequest(url: urlWithPath)
        
        apiClient.dataTask(request: request, method: HTTPMethod.get, completion: completion)
    }
}


