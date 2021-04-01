import Foundation

class QBGraphQLQuery {
    typealias HTTPHeaders = [String: String]
    
    private var contentTypeHeader: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }

    var url: URL
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers + contentTypeHeader
        request.httpBody = body.data(using: .utf8)
        request.timeoutInterval = timeoutInterval
        return request
    }
    var headers: HTTPHeaders
    var timeoutInterval: TimeInterval

    var body: String {
        assertionFailure("property `body` should be overridden")
        return ""
    }

    init(with url: URL,
         timeoutInterval: TimeInterval = 5.0,
         additionalHeaders: HTTPHeaders = HTTPHeaders()) {
        self.url = url
        self.headers = HTTPHeaders() + additionalHeaders
        self.timeoutInterval = timeoutInterval
    }
}
