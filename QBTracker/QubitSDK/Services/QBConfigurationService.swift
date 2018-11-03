//
//  ConfigurationService.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

protocol QBConfigurationService {
    func getConfigution(with completion: ((Result<QBConfigurationEntity>) -> Void)?)
}

class QBConfigurationServiceImp: QBConfigurationService {
    private let trackingId: String
    private let apiClient: QBAPIClient = {
        return QBAPIClient()
    }()
    private let baseUrl = "https://s3-eu-west-1.amazonaws.com/qubit-mobile-config/"
    private var url: URL? {
        let urlString = self.baseUrl + self.trackingId + ".json"
        return URL(string: urlString)
    }
    
    init(withTrackingId trackingId: String) {
        self.trackingId = trackingId
    }
    
    func getConfigution(with completion: ((Result<QBConfigurationEntity>) -> Void)?) {
        guard let url = self.url else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for configuration is nil"]) as Error
            QBLog.error("URL for configuration is nil")
            completion?(.failure(error))
            assert(false, "URL for configuration is nil")
            return
        }
        
        let request = URLRequest(url: url)
        apiClient.makeRequestAndDecode(request, withMethod: HTTPMethod.get, then: completion)
    }
}
