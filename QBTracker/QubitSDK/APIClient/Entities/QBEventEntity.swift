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
        case "qubit.session":
            self = .session
        case "View":
            self = .view
        default:
            self = .other
        }
    }
}

struct QBEventEntity {
    let type: String
    let eventData: String
    
    var enumType: QBEventType {
        return QBEventType(type: type)
    }
    
    private var context: QBContextEntity?
    private var meta: QBMetaEntity?
    private var session: QBSessionEntity?
    
    init(type: String = "", eventData: String = "", context: QBContextEntity? = nil, meta: QBMetaEntity? = nil, session: QBSessionEntity? = nil) {
        self.type = type
        self.eventData = eventData
        self.context = context
        self.meta = meta
        self.session = session
    }
    
    mutating func setBatchTs(batchTs: Int64) {
        self.meta?.batchTs = batchTs
    }
    
    mutating func add(context: QBContextEntity? = nil, meta: QBMetaEntity? = nil) {
        self.context = context
        self.meta = meta
    }
    
    func codable() -> [String: Any]? {
        
        func convert(jsonData: Data?) -> Any? {
            if let data = jsonData {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: [])
                } catch {
                }
            }
            return nil
        }
        
        if let data = eventData.data(using: .utf8) {
            do {
                guard var jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else { return nil }
                if let context: QBContextEntity = self.context, let contextData: Data = try? JSONEncoder().encode(context) {
                    jsonObject["context"] =  convert(jsonData: contextData)
                }
                if let meta: QBMetaEntity = self.meta, let metaData: Data = try? JSONEncoder().encode(meta) {
                    jsonObject["meta"] =  convert(jsonData: metaData)
                }
                if let session: QBSessionEntity = self.session, let sessionData: Data = try? JSONEncoder().encode(session) {
                    if let sessionDictonary = convert(jsonData: sessionData) as? [String: Any] {
                        jsonObject += sessionDictonary
                    }
                }
                return jsonObject
            } catch {
                return nil
            }
            
        }
        return nil
    }
}

// MARK: Instance creation event
extension QBEventEntity {
    static func event(type: String, string: String) -> QBEventEntity? {
        if string.isJSONValid() == false {
            QBLog.error("Please check your `data: String` parameter has valid JSON format")
            return nil
        }
        
        return QBEventEntity(type: type, eventData: string)
    }
    
    static func event(type: String, dictionary: [String: Any]) -> QBEventEntity? {
        if let JSONData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted), let JSONString = String(data: JSONData, encoding: .utf8) {
            let event = QBEventEntity(type: type, eventData: JSONString)
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
    
    static func create(with event: QBEvent, configuration: QBConfigurationEntity) -> QBEventEntity? {
        guard let type = event.type, let context = event.context, let meta = event.meta else { return nil }
        let typeWithNamespace = QBEventTypeTransformer.transformEventType(eventType: type, configuration: configuration)
        guard let contextEntity = QBContextEntity.create(with: context), let metaEntity = QBMetaEntity.create(with: meta, typeWithNamespaceAndVertical: typeWithNamespace) else { return nil }
        let session = QBSessionEntity.create(with: event.session)
        let eventEntity = QBEventEntity(type: type, eventData: event.data ?? "", context: contextEntity, meta: metaEntity, session: session)
        return eventEntity
    }
}
