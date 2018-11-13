//
//  QBLookupService.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBLookupService {
    func getLookup(forDeviceId id: String, completion: ((Result<QBLookupEntity>) -> Void)?)
}

class QBLookupServiceImp: QBLookupService {
    private let configurationManager: QBConfigurationManager
    private let apiClient: QBAPIClient = {
        return QBAPIClient()
    }()
    
    init(withConfigurationManager configurationManager: QBConfigurationManager) {
        self.configurationManager = configurationManager
    }
    
    func getLookup(forDeviceId id: String, completion: ((Result<QBLookupEntity>) -> Void)?) {
        guard let url = configurationManager.configuration.lookupEndpointUrl() else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for lookup is nil"]) as Error
            QBLog.error("URL for lookup is nil")
            completion?(.failure(error))
            assert(false, "URL for lookup is nil")
            return
        }
        
        var urlWithPath = url
        urlWithPath.appendPathComponent(configurationManager.trackingId)
        urlWithPath.appendPathComponent(id)
        
        var request = URLRequest(url: urlWithPath)
        request.timeoutInterval = Double(configurationManager.configuration.lookupRequestTimeout)
        
        apiClient.makeRequestAndDecode(request, withMethod: HTTPMethod.get, then: completion)
    }
}
