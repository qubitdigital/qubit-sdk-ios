//
//  NSManagedObjectConvertible.swift
//  QBTracker
//
//  Created by Dariusz Zajac on 24/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CoreData

protocol NSManagedObjectConvertible {
    associatedtype T: NSManagedObject
    
    func entityType() -> T.Type
    func propertiesMap() -> [String : String]
}

//extension NSManagedObjectConvertible {
//    func properties() -> [String : String] {
//        var propertiesDictionary: [String : String] = [:]
//        let propertyNames = Mirror(reflecting: self).children.flatMap { $0.label }
//
//        propertyNames.forEach { (property) in
//            propertiesDictionary[property] = property
//        }
//
//        return propertiesDictionary
//    }
//}

