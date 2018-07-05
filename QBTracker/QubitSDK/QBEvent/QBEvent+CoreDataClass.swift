//
//  QBEvent+CoreDataClass.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 30/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//
//

import Foundation
import CoreData

@objc(QBEvent) class QBEvent: NSManagedObject {}
@objc(QBMetaEvent) class QBMetaEvent: NSManagedObject {}
@objc(QBContextEvent) class QBContextEvent: NSManagedObject {}
@objc(QBSessionEvent) class QBSessionEvent: NSManagedObject {}
