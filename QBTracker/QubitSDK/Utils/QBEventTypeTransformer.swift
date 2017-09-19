//
//  QBEventTypeTransformer.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 19/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

class QBEventTypeTransformer {
    static let dot = "."
    
    static func transformEventType(eventType: String, configuration: QBConfigurationEntity) -> String {
        if eventType.starts(with: "qubit.") {
            return eventType
        }
        
        let eventTypeWithVertical = addVertical(eventType: eventType, vertical: configuration.vertical)
        let eventTypeWithNamespaceAndVertical = addNameSpace(eventType: eventTypeWithVertical, namespace: configuration.namespace)
        
        return eventTypeWithNamespaceAndVertical
    }
    
    private static func addVertical(eventType: String, vertical: String) -> String {
        if vertical.isEmpty || eventType.contains(dot) || eventType.starts(with: vertical) {
            return eventType
        }
        let capitalizedEventType = String(eventType.characters.prefix(1)).uppercased() + String(eventType.characters.dropFirst())
        
        return vertical + capitalizedEventType
    }
    
    private static func addNameSpace(eventType: String, namespace: String) -> String {
        if namespace.isEmpty || namespace.contains(dot) {
            return eventType
        }
        return namespace + dot + eventType
    }
    
}
