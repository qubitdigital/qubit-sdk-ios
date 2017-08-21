//
//  ConfigurationManager.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

let configUrl = "https://s3-eu-west-1.amazonaws.com/qubit-mobile-config/"

func getConfigUrl(forId id: String) -> URL? {
    let urlString = configUrl + id + ".json"
    return URL(string: urlString)
}

func getConfigution(forId id: String, completion: ((Result<ConfigDTO>) -> ())?) {
    print("func getConfigution()\n")
    guard let url = getConfigUrl(forId: id) else {
        print("URL for configuration is nil")
        return
    }
    
    let request = URLRequest(url: url)
    
    dataTask(request: request, method: HTTPMethod.get, completion: completion)
}

getConfigution(forId: "roeld") { result in
    switch result {
    case .success(let config):
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(config)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
        }
        catch {
        }
        
        print("config = \(config)")
    case .failure(let error):
        print("error = \(error)")
    }
}
