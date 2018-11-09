//
//  QBDictionarySerializer.swift
//  QubitSDK
//
//  Created by Andrzej Zuzak on 08/11/2018.
//  Copyright © 2018 Qubit. All rights reserved.
//

import Foundation

protocol QBDictionaryConverting {
    
    func convert(_ dictionary: [String: Any]) -> [String: Any]
}

private extension Double {
    
    var serializedWithDotSeparator: NSDecimalNumber {
        return NSDecimalNumber(floatLiteral: self)
    }
}

struct QBDecimalsWithDotConverter: QBDictionaryConverting {
    
    func convert(_ dict: [String : Any]) -> [String : Any] {
        var convertedDict: [String: Any] = [:]

        dict.keys.forEach {
            if let decimalValue = dict[$0] as? Double {
                convertedDict[$0] = decimalValue.serializedWithDotSeparator
            } else {
                convertedDict[$0] = dict[$0]
            }
        }

        return convertedDict
    }
}
