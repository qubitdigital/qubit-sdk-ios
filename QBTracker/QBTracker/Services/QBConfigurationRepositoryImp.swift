//
//  ConfigurationRepository.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBConfigurationRepositoryImp: QBConfigurationRepository {
    
    private let configUrl = "https://s3-eu-west-1.amazonaws.com/qubit-mobile-config/"
    private let apiClient: QBAPIClient = {
        return QBAPIClient()
    }()
    
    private func getConfigUrl(forId id: String) -> URL? {
        let urlString = configUrl + id + ".json"
        return URL(string: urlString)
    }
    
    func getConfigution(forId id: String, completion: ((Result<QBConfigurationEntity>) -> ())?) {
        guard let url = getConfigUrl(forId: id) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "URL for configuration is nil"]) as Error
            print("URL for configuration is nil")
            completion?(.failure(error))
            return
        }
        
        let request = URLRequest(url: url)
        
        apiClient.dataTask(request: request, method: HTTPMethod.get, completion: completion)
    }
    
}

