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

protocol DictionaryInitializable {
    
    init(withDict dict: [String: Any]) throws
}

class QBAPIClient {
    
    func setup(request: URLRequest, method: HTTPMethod) -> URLRequest {
        var request = request
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
    private static func check(statusCode: Int) -> Error? {
        if 200...299 ~= statusCode {
            return nil
        }
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status code = \(statusCode) is not correct"]) as Error
        QBLog.error("Status code = \(statusCode), status is wrong \n")
        return error
    }
}

// MARK: - Decoding

extension QBAPIClient {
    
    func makeRequestAndDecode<T: Decodable>(_ request: URLRequest, withMethod: HTTPMethod, then: ((Result<T>) -> Void)?) {
        let request = setup(request: request, method: withMethod)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            QBDispatchQueueService.runSync(type: .upload) {
                if let error = error {
                    QBLog.error("❗️ Error = \(String(describing: error))")
                    then?(.failure(error))
                    return
                }
                
                QBLog.debug("✅ Response = \(response?.description ?? "") \n")
                if let response = response as? HTTPURLResponse,
                    let statusError = QBAPIClient.check(statusCode: response.statusCode) {
                    then?(.failure(statusError))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request = \(request)"]) as Error
                    QBLog.error("❗️ Data was not retrieved from request = \(request) \n")
                    then?(.failure(error))
                    return
                }
                
                QBAPIClient.decodeResponse(with: data, completion: then)
            }
        }
        
        task.resume()
    }
    
    private static func decodeResponse<T: Decodable>(with data: Data, completion: ((Result<T>) -> Void)?) {
        let responseString = String(data: data, encoding: .utf8)
        QBLog.debug("✅ ResponseString = \(responseString?.description ?? "") \n")
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            
            QBLog.debug("✅ Decoded object = \(decodedObject)")
            if let statusEntity = decodedObject as? QBStatusEntity,
                let statusError = self.check(statusCode: statusEntity.status.code) {
                completion?(.failure(statusError))
                return
            }
            
            completion?(.success(decodedObject))
        } catch {
            QBLog.error("❗️ Error trying to convert data to JSON, error = \(error) \n")
            completion?(.failure(error))
        }
    }
}

// MARK: - Deserializing
// This section was created because Codable is so strongly typed that it doesn't support key-value maps in decoding.
// Until this functionality is available without hacking below code should be used.

extension QBAPIClient {
    
    func makeRequestAndDeserialize<T: DictionaryInitializable>(_ request: URLRequest, withMethod: HTTPMethod, then: ((Result<T>) -> Void)?) {
        let request = setup(request: request, method: withMethod)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            QBDispatchQueueService.runSync(type: .upload) {
                if let error = error {
                    QBLog.error("❗️ Error = \(String(describing: error))")
                    then?(.failure(error))
                    return
                }
                
                QBLog.debug("✅ Response = \(response?.description ?? "") \n")
                if let response = response as? HTTPURLResponse,
                    let statusError = QBAPIClient.check(statusCode: response.statusCode) {
                    then?(.failure(statusError))
                    return
                }
                
                guard let data = data else {
                    QBLog.error("❗️ Data was not retrieved from request = \(request) \n")
                    return
                }
                
                QBAPIClient.deserializeResponse(from: data, then: then)
            }
        }
        
        task.resume()
    }
    
    private static func deserializeResponse<T: DictionaryInitializable>(from data: Data, then: ((Result<T>) -> Void)?) {
        guard let deserializedObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonDict = deserializedObject as? [String: Any] else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request"]) as Error
                QBLog.error("❗️ Data was not deserialized: \(error.localizedDescription)\n")
                then?(.failure(error))
                return
        }
        
        QBLog.debug("✅ Deserialized object as JSON key-value map = \(jsonDict.debugDescription)")
        
        do {
            let docodedEntity = try T(withDict: jsonDict)
            then?(.success(docodedEntity))
        } catch {
            QBLog.error("❗️ Error trying to convert JSON key-value map to entity, error = \(error) \n")
            then?(.failure(error))
        }
    }
}
