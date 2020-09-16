import Foundation
import UIKit
import CoreData

enum LastEventType: String {
    case view
    case user

    func allTypes() -> [LastEventType] {
        return [.view, .user]
    }
}

final class QBLastEventManager {
    private let databaseManager: QBDatabaseManager

    init(databaseManager: QBDatabaseManager) {
        self.databaseManager = databaseManager
    }

    @discardableResult
    func createLastEventIfNeeded(_ event: QBEventEntity) -> QBLastEvent? {
        let eventType = String(event.type.lowercased())
        let type: String

        if eventType.contains(LastEventType.view.rawValue) {
            type = LastEventType.view.rawValue
        } else if eventType.contains(LastEventType.user.rawValue) {
            type = LastEventType.user.rawValue
        } else {
            return nil
        }

        let lastEvent = findLastEvent(of: type) ?? databaseManager.insert(entityType: QBLastEvent.self)

        lastEvent?.type = type
        lastEvent?.data = event.eventData
        lastEvent?.dateAdded = NSDate()

        return lastEvent
    }

    func lastEvent(of type: String) -> QBLastEvent? {
        return findLastEvent(of: type)
    }
}

private extension QBLastEventManager {
    func findLastEvent(of type: String) -> QBLastEvent? {
        let predicate = NSPredicate(format: "type == %@", type as CVarArg)
        let events = databaseManager.query(entityType: QBLastEvent.self, predicate: predicate)
        return events.first
    }
}
