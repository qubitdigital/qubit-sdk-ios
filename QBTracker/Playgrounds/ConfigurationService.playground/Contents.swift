import UIKit
import PlaygroundSupport
import QBTracker

func testExample() {
    let test = ConfigurationRepositoryImp()
    test.getConfigution(forId: "test") { result in
        switch result {
        case .success(let config):
            print("config = \(config)")
//            XCTAssert(true)
        case .failure(let error):
            print("error = \(error)")
//            XCTAssert(false)
        }
    }
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

testExample()


//enum Result<T> {
//    case success(T)
//    case failure(Error)
//}
//
//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case delete = "DELETE"
//}
//
//private func dataTask<T: Decodable>(request: URLRequest, method: HTTPMethod, completion: ((Result<T>) -> ())?) {
//    var request = request
//    request.httpMethod = method.rawValue
//    
//    let session = URLSession(configuration: .default)
//    
//    let task = session.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print("error = \(String(describing: error))")
//            completion?(.failure(error))
//            return
//        }
//        
//        print("response = \(response?.description ?? "") \n")
//        
//        guard let data = data else {
//            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request = \(request)"]) as Error
//            print("Data was not retrieved from request = \(request) \n")
//            completion?(.failure(error))
//            return
//        }
//        
//        let responseString = String(data: data, encoding: .utf8)
//        print("responseString = \(responseString?.description ?? "") \n")
//        
//        if let response = response as? HTTPURLResponse {
//            guard (200...299 ~= response.statusCode) else {
//                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Status code = \(response.statusCode) is not correct"]) as Error
//                print("Status code = \(response.statusCode), status is wrong \n")
//                completion?(.failure(error))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let config = try decoder.decode(T.self, from: data)
//                print("decoded object = \(config)")
//                completion?(.success(config))
//            } catch {
//                print("error trying to convert data to JSON, error = \(error) \n")
//                completion?(.failure(error))
//            }
//        }
//    }
//    
//    task.resume()
//}
//
//let configUrl = "https://s3-eu-west-1.amazonaws.com/qubit-mobile-config/"
//func getConfigUrl(forId id: String) -> URL? {
//    let urlString = configUrl + id + ".json"
//    return URL(string: urlString)
//}
//
//struct ConfigDTO: Codable {
//    let sendAutoViewEvents: Bool
//    let sendAutoInteractionEvents: Bool
//    let sendGeoData: Bool
//    let disabled: Bool
//    let configurationReloadInterval: Int
//    let queueTimeout: Int
//    let vertical: String
//    
//    private enum CodingKeys : String, CodingKey {
//        case sendAutoViewEvents = "send_auto_view_events"
//        case sendAutoInteractionEvents = "send_auto_interaction_events"
//        case sendGeoData = "send_geo_data"
//        case disabled
//        case configurationReloadInterval = "configuration_reload_interval"
//        case queueTimeout = "queue_timeout"
//        case vertical
//    }
//}
//
//func getConfigution(forId id: String, completion: ((Result<ConfigDTO>) -> ())?) {
//    print("func getConfigution()\n")
//    guard let url = getConfigUrl(forId: id) else {
//        print("URL for configuration is nil")
//        return
//    }
//    
//    let request = URLRequest(url: url)
//    
//    dataTask(request: request, method: HTTPMethod.get, completion: completion)
//}
//
//getConfigution(forId: "roeld") { result in
//    switch result {
//    case .success(let config):
//        
//        let jsonEncoder = JSONEncoder()
//        jsonEncoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonData = try jsonEncoder.encode(config)
//            let jsonString = String(data: jsonData, encoding: .utf8)
//            print("JSON String : " + jsonString!)
//        }
//        catch {
//        }
//        
//        print("config = \(config)")
//    case .failure(let error):
//        print("error = \(error)")
//    }
//}

PlaygroundPage.current.needsIndefiniteExecution = true
