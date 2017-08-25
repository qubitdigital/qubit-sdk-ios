//
//  UserDefaults+Extensions.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

extension UserDefaults {
    var onboardingCompleted: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
