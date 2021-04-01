import Foundation

class QBPlacementCallbackManager: NSObject {
    static var shared = QBPlacementCallbackManager()

    private var pendingCallbacks: [String] = []
    private var reachability = QBReachability()

    override private init() {
        super.init()

        reachability?.whenReachable = { [weak self] reachable in
            self?.flush()
        }
        try? reachability?.startNotifier()
    }

    func call(_ callback: String) {
        guard reachability?.isReachable == true else {
            pendingCallbacks.append(callback)
            return
        }
        guard let url = URL(string: callback) else {
            QBLog.error("Invalid callback URL in \(#function): \(callback)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue

        let jsonDict: [String: Any] = ["id": QBDevice.getId()]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) else {
            QBLog.error("Could not attach deviceId to callback request: \(url)")
            return
        }

        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request).resume()
        QBLog.info("Callback URL: \(url) was invoked")
    }
}

private extension QBPlacementCallbackManager {
    func flush() {
        while !pendingCallbacks.isEmpty {
            call(pendingCallbacks.removeFirst())
        }
    }
}
