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
    
    func testLookupEntity() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "lookup_entity", ofType: "json"), let data = try? Data(contentsOf: URL.init(fileURLWithPath: path)) else {
            XCTAssert(false)
            return
        }
        let decoder = JSONDecoder()
        let lookup: QBLookupEntity? = try? decoder.decode(QBLookupEntity.self, from: data)
        XCTAssert(lookup != nil)
    }
    
    func testExperiencesEntity() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "experiences_entity", ofType: "json"),
            let data = try? Data(contentsOf: URL.init(fileURLWithPath: path)) else {
                XCTAssert(false)
                return
        }
        
        guard let deserializedObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonDict = deserializedObject as? [String: Any] else {
                XCTFail("Could not deserialize experiences")
                return
        }
        
        guard let experiencesEntity = try? QBExperiencesEntity(withDict: jsonDict) else {
            XCTFail("Could not initialize QBExperiencesEntity")
            return
        }
        
        XCTAssertEqual(experiencesEntity.experiencePayloads.count, 1)
        
        guard let firstExperience = experiencesEntity.experiencePayloads.first else {
            XCTFail("Experience which should be present is nil")
            return
        }
        
        guard let stringFieldFromPayload = firstExperience.payload["stringField"] as? String,
            let intFieldFromPayload = firstExperience.payload["intField"] as? Int else {
                XCTFail("Payload fields not deserialized properly")
                return
        }
        
        XCTAssertEqual(stringFieldFromPayload, "string")
        XCTAssertEqual(intFieldFromPayload, 1)
    }
    
}
