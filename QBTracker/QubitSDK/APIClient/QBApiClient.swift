//
//  QBAPIClient
//  QubitSDK
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

class QBAPIClient {
    
    func setup(request: URLRequest, method: HTTPMethod) -> URLRequest {
        var request = request
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
    func dataTask<T: Decodable>(request: URLRequest, method: HTTPMethod, completion: ((Result<T>) -> Void)?) {
        let request = setup(request: request, method: method)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            QBDispatchQueueService.runSync(type: .upload) {
                if let error = error {
                    QBLog.error("Error = \(String(describing: error))")
                    completion?(.failure(error))
                    return
                }
                QBLog.debug("✅ Response = \(response?.description ?? "") \n")
                guard let data = data else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request = \(request)"]) as Error
                    QBLog.error("Data was not retrieved from request = \(request) \n")
                    completion?(.failure(error))
                    return
                }
                
                let responseString = String(data: data, encoding: .utf8)
                QBLog.debug("✅ ResponseString = \(responseString?.description ?? "") \n")
                
                if let response = response as? HTTPURLResponse {
                    guard 200...299 ~= response.statusCode else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status code = \(response.statusCode) is not correct"]) as Error
                        QBLog.error("Status code = \(response.statusCode), status is wrong \n")
                        completion?(.failure(error))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let config = try decoder.decode(T.self, from: data)
                        QBLog.debug("✅ Decoded object = \(config)")
                        completion?(.success(config))
                    } catch {
                        QBLog.error("❗️ Error trying to convert data to JSON, error = \(error) \n")
                        completion?(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
    
}
