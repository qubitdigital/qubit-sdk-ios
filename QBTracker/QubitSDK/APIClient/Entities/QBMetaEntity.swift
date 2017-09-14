//
//  QBMetaEntity.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

struct QBMetaEntity: Codable {
    let id: String
    let ts: Int
    let trackingId: String
    let type: String
    let source: String
    let seq: Int
    let batchTs: Int
}

extension QBMetaEntity {
    func fillQBMetaEvent(meta: inout QBMetaEvent) -> QBMetaEvent {
        meta.id = self.id
        meta.ts = NSNumber(value: self.ts)
        meta.trackingId = self.trackingId
        meta.type = self.type
        meta.source = self.source
        meta.seq = NSNumber(value: self.seq)
        meta.batchTs = NSNumber(value: self.batchTs)
        return meta
    }
    
    static func create(with meta: QBMetaEvent, verticalType: String) -> QBMetaEntity? {
        guard
            let id = meta.id,
            let ts = meta.ts?.intValue,
            let trackingId = meta.trackingId,
            let source = meta.source,
            let seq = meta.seq?.intValue,
            let batchTs = meta.batchTs?.intValue
            else { return nil }
        
        let metaEntity = QBMetaEntity(id: id, ts: ts, trackingId: trackingId, type: verticalType, source: source, seq: seq, batchTs: batchTs)
        return metaEntity
    }
}
