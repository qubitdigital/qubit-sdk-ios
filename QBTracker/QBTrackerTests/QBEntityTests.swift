//
//  QBEntityTests.swift
//  QubitSDKTests
//
//  Created by Jacek Grygiel on 15/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import XCTest
@testable import QubitSDK

class QBEntityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConfigurationEntity() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "configuration_entity", ofType: "json"), let data = try? Data(contentsOf: URL.init(fileURLWithPath: path)) else {
            XCTAssert(false)
            return
        }
        let decoder = JSONDecoder()
        let configuration: QBConfigurationEntity? = try? decoder.decode(QBConfigurationEntity.self, from: data)
        XCTAssert(configuration != nil)
    }
    
}
