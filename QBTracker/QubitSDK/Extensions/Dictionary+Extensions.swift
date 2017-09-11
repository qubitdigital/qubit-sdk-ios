//
//  Dictionary+Extensions.swift
//  QubitSDK
//
//  Created by Jacek Grygiel on 10/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func convert(jsonData: Data?) -> Any? {
        if let data = jsonData {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
            }
        }
        return nil
    }
    
}
