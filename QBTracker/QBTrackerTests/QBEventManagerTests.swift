//
//  QBEventManagerTests.swift
//  QubitSDKTests
//
//  Created by Jacek Grygiel on 12/09/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import XCTest
@testable import QubitSDK

class QBEventManagerTests: XCTestCase, QBConfigurationManagerDelegate, QBSessionManagerDelegate {
    
    var eventManager: QBEventManager?
    var configurationManager: QBConfigurationManager?
    var sessionManager: QBSessionManager?
    var lookupManager:QBLookupManager?
    var expectation: XCTestExpectation?
    override func setUp() {
        super.setUp()
        expectation = XCTestExpectation(description: "setup event manager")
        configurationManager = QBConfigurationManager(withTrackingId: "miquido", delegate: self)
        sessionManager = QBSessionManager(delegate: self)
        lookupManager = QBLookupManager(withConfigurationManager: configurationManager!)
        eventManager = QBEventManager(withConfigurationManager: configurationManager!, sessionManager: sessionManager!, lookupManager: lookupManager!)
        waitForExpectations(timeout: 2.0, handler: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func newSessionStarted() {
    }
    func configurationUpdated() {
        expectation?.fulfill()
        testExample()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
