//
//  QBDatabaseHelper.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 28/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

class QBDatabaseHelper {
    
    class func insert(event: QBEventEntity) {
        
    }
    
    class func delete(event: QBEventEntity) {
        
    }
    
    class func delete(events: [QBEventEntity]) {
        
    }
    
    class func queryEvents(predicate: NSPredicate?) -> [QBEventEntity] {
        
        var events: [QBEventEntity] = []
        let dbEvents = QBDatabaseManager.shared.query(entityType: QBEvent.self, predicate: predicate)
        
        dbEvents.forEach { (dbEvent) in
            let event = dbEventToEvent(event: dbEvent)
            events.append(event)
        }
        
        return events
    }
    
    private class func eventToDBEvent(event: QBEventEntity)  -> QBEvent {
        return QBEvent()
    }
    
    private class func dbEventToEvent(event: QBEvent) -> QBEventEntity {
        let context = QBContextEntity(sessionNumber: "", id: 0, viewNumber: "", viewTs: 0, sessionTs: "", sessionViewNumber: 0)
        let meta = QBMetaEntity(id: 0, ts: "", trackingId: "", type: 0, source: "", seq: 0)
        return QBEventEntity(context: context, meta: meta)
    }
}
