//
//  QBEvent.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

enum QBEventType: String {
    case session
    case view
    case other
    
    public init(type: String) {
        switch type {
        case "session":
            self = .session
            break
        case "View":
            self = .view
            break
        default:
            self = .other
        }
    }
}

struct QBEventEntity: Codable {
    let type: String
    let eventData: String
    
    var context: QBContextEntity?
    var meta: QBMetaEntity?
    var session: QBSessionEntity?
    
    init(type: String = "", eventData: String = "", context: QBContextEntity? = nil, meta: QBMetaEntity? = nil, session: QBSessionEntity? = nil) {
        self.type = type
        self.eventData = eventData
        self.context = context
        self.meta = meta
        self.session = session
    }
    
    func codable() -> [String : Any]? {
        
        func convert(jsonData: Data?) -> Any? {
            if let data = jsonData {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: [])
                } catch {
                }
            }
            return nil
        }
        
        if let data = eventData.data(using: .utf8), let jsonObjectRef = (try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : Any]) ?? [String: Any]() {
            var jsonObject = jsonObjectRef
            if let context: QBContextEntity = self.context, let contextData: Data = try? JSONEncoder().encode(context) {
                jsonObject["context"] =  convert(jsonData: contextData)
            }
            if let meta: QBMetaEntity = self.meta, let metaData: Data = try? JSONEncoder().encode(meta) {
                jsonObject["meta"] =  convert(jsonData: metaData)
            }
            if let session: QBSessionEntity = self.session, let sessionData: Data = try? JSONEncoder().encode(session) {
                jsonObject["session"] =  convert(jsonData: sessionData)
            }
            return jsonObject
        }
        return nil
    }
}

// MARK: Instance creation event
extension QBEventEntity {
    static func event(type: String, dictionary: [String: Any]) -> QBEventEntity? {
        if let JSONData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted), let JSONString = String(data: JSONData, encoding: .utf8) {
            let event = QBEventEntity(type: type, eventData: JSONString , context: nil, meta: nil, session: nil)
            return event
        } else {
            return nil
        }
    }
}

// MARK: - Bridges
extension QBEventEntity {
    func fillQBEvent(event: inout QBEvent, context: inout QBContextEvent, meta: inout QBMetaEvent, session: inout QBSessionEvent) -> QBEvent {
        event.data = self.eventData
        event.type = self.type
        event.dateAdded = NSDate()
        event.context = self.context?.fillQBContextEvent(context: &context)
        event.meta = self.meta?.fillQBMetaEvent(meta: &meta)
        event.session = self.session?.fillQBSessionEvent(session: &session)
        
        return event
    }
    
    static func create(with event: QBEvent) -> QBEventEntity? {
        guard let type = event.type, let context = event.context, let meta = event.meta else { return nil }
        guard let contextEntity = QBContextEntity.create(with: context), let metaEntity = QBMetaEntity.create(with: meta) else { return nil }
        let session = QBSessionEntity.create(with: event.session)
        let eventEntity = QBEventEntity(type: type, eventData: "", context: contextEntity, meta: metaEntity, session: session)
        return eventEntity
    }
}

// MARK: - Helpers
extension QBEventEntity {
    static func getEnumEventType(fromString string: String) -> QBEventType {
        return QBEventType(type: string)
    }
}
