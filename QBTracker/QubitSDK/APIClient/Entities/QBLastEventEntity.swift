import Foundation
import CoreData

struct QBLastEventEntity {
    var data: String?
    var dateAdded: Date?
    var type: String?

    private var dict: [String: Any]?

    init(from lastEvent: QBLastEvent) {
        self.data = lastEvent.data
        self.dateAdded = lastEvent.dateAdded as Date?
        self.type = lastEvent.type

        if let jsonData = data?.data(using: .utf8) {
            dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        }
    }

    func value(for key: String) -> Any? {
        return dict?[key]
    }
}
