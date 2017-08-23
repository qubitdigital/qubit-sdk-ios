//
//  QBContextEntity.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBContextEntity: Codable {
    let sessionNumber: String
    let id: Int
    let viewNumber: String
    let viewTs: Int
    let sessionTs: String
    let sessionViewNumber: Int
}
