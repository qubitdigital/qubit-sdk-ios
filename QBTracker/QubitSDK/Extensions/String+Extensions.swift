//
//  String+md5.swift
//  QubitSDK
//
//  Created by Dariusz Zajac on 22/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        guard let str = self.cString(using: String.Encoding.utf8) else {
            return self
        }
        
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str, strLen, result)

        let hash = NSMutableString()
        for index in 0..<digestLen {
            hash.appendFormat("%02x", result[index])
        }

        result.deallocate()

        return String(format: hash as String)
    }
}

extension String {
    func isJSONValid() -> Bool {
        if let data = self.data(using: .utf8) {
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) != nil
        } else {
            return false
        }
    }
}
