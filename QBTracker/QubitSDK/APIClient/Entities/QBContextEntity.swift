//
//  QBContextEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBContextEntity: Codable {
    let sessionNumber: Int
    let id: String
    let viewNumber: Int
    let viewTs: Int
    let sessionTs: Int
    let sessionViewNumber: Int
}
