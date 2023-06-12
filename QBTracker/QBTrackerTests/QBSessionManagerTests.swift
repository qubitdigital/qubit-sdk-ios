//
//  QBSessionManagerTests.swift
//  QubitSDKTests
//
//  Created by Michał Balawajder on 12/06/2023.
//  Copyright © 2023 Qubit. All rights reserved.
//

import Foundation
import XCTest

@testable import QubitSDK

class QBSessionManagerTests: XCTestCase {
    override func setUp() {
        UserDefaults.standard.session = nil
    }
    
    func testSessionManagerCreatingSessionTriggersDelegate() {
        let sessionStartExpectation = expectation(description: "Session has started")
        let delegate = QBSessionManagerDelegateMock(sessionStartExpectation)
        
        let _ = QBSessionManager(delegate: delegate).session // be sure to initialize first
        
        waitForExpectations(timeout: 0.05) { error in
            XCTAssertNil(error)
        }
    }
    
    func testSessionManagerSessionEventCount() {
        let delegate = QBSessionManagerDelegateMock()
        
        let sut = QBSessionManager(delegate: delegate)
        let _ = sut.session // be sure to initialize first
        
        sut.eventAdded(type: .other, timestampInMS: 0)
        sut.eventAdded(type: .view, timestampInMS: 0)
        sut.eventAdded(type: .session, timestampInMS: 0)
        sut.eventAdded(type: .session, timestampInMS: 0)
        sut.eventAdded(type: .view, timestampInMS: 0)
        sut.eventAdded(type: .view, timestampInMS: 0)
        sut.eventAdded(type: .other, timestampInMS: 0)
        sut.eventAdded(type: .other, timestampInMS: 0)
        sut.eventAdded(type: .view, timestampInMS: 0)
        sut.eventAdded(type: .other, timestampInMS: 0)
        
        XCTAssertEqual(sut.session.sequenceEventNumber, 10)
    }
}

private class QBSessionManagerDelegateMock: QBSessionManagerDelegate {
    let sessionStartExpectation: XCTestExpectation?
    
    init(_ sessionStartedExpectation: XCTestExpectation? = nil) {
        self.sessionStartExpectation = sessionStartedExpectation
    }
    
    func newSessionStarted() {
        sessionStartExpectation?.fulfill()
    }
}


