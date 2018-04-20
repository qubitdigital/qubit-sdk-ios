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
    let ts: Int64
    let trackingId: String
    let type: String
    let source: String
    let seq: Int
    var batchTs: Int64
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
    
    static func create(with meta: QBMetaEvent, typeWithNamespaceAndVertical: String) -> QBMetaEntity? {
        guard
            let id = meta.id,
            let ts = meta.ts?.int64Value,
            let trackingId = meta.trackingId,
            let source = meta.source,
            let seq = meta.seq?.intValue,
            let batchTs = meta.batchTs?.intValue
            else { return nil }
        
        let metaEntity = QBMetaEntity(id: id, ts: ts, trackingId: trackingId, type: typeWithNamespaceAndVertical, source: source, seq: seq, batchTs: Int64(batchTs))
        return metaEntity
    }
}
