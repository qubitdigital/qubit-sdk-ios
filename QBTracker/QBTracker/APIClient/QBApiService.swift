//
//  QBApiService.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

private func dataTask<T: Decodable>(request: URLRequest, method: HTTPMethod, completion: ((Result<T>) -> ())?) {
    var request = request
    request.httpMethod = method.rawValue
    
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error = \(String(describing: error))")
            completion?(.failure(error))
            return
        }
        
        print("Response = \(response?.description ?? "") \n")
        
        guard let data = data else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request = \(request)"]) as Error
            print("Data was not retrieved from request = \(request) \n")
            completion?(.failure(error))
            return
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("ResponseString = \(responseString?.description ?? "") \n")
        
        if let response = response as? HTTPURLResponse {
            guard (200...299 ~= response.statusCode) else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Status code = \(response.statusCode) is not correct"]) as Error
                print("Status code = \(response.statusCode), status is wrong \n")
                completion?(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let config = try decoder.decode(T.self, from: data)
                print("Decoded object = \(config)")
                completion?(.success(config))
            } catch {
                print("Error trying to convert data to JSON, error = \(error) \n")
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
}
