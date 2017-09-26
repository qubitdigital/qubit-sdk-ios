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
        
        let eventTypeWithNamespace = addNameSpace(eventType: eventType, namespace: configuration.namespace)
        
        return eventTypeWithNamespace
    }
    
    private static func addNameSpace(eventType: String, namespace: String) -> String {
        if namespace.isEmpty || namespace.contains(dot) {
            return eventType
        }
        return namespace + dot + eventType
    }
    
}
