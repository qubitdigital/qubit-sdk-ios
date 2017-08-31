//
//  QBEventRespositoryImp.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBEventRepositoryImp: QBEventRepository {
    
    private let configUrl = "https://gong-eb.qubit.com/events/raw/roeld"
    private let apiClient: QBAPIClient = {
        return QBAPIClient()
    }()
    
    func sendEvent(withString string: String, completion: ((Result<QBStatusEntity>) -> Void)?) {
        print("func sendEvent()\n")

        guard let url = URL(string: configUrl) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for send events is nil"]) as Error
            print("URL for send events is nil")
            completion?(.failure(error))
            return
        }
        
        let request = URLRequest(url: url)
//        request.httpBody = 
        
        apiClient.dataTask(request: request, method: HTTPMethod.post, completion: completion)
    }
    
    func sendEvents(events: [QBEventEntity], completion: ((Result<QBStatusEntity>) -> Void)?) {
        print("func sendEvents()\n")
        
        guard let url = URL(string: configUrl) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL for send events is nil"]) as Error
            print("URL for send events is nil")
            completion?(.failure(error))
            return
        }
        
        let request = URLRequest(url: url)
        //        request.httpBody =
        
        apiClient.dataTask(request: request, method: HTTPMethod.post, completion: completion)
    }
    
}
