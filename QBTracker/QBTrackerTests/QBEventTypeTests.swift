//
//  QBEventTypeTests.swift
//  QubitSDKTests
//
//  Created by Michał Balawajder on 09/06/2023.
//  Copyright © 2023 Qubit. All rights reserved.
//

import Foundation
import XCTest

@testable import QubitSDK

class QBEventTypeTests: XCTestCase {
    
    func testTypeNameResolution() {
        var sut = QBEventType(type: "qubit.session")
        XCTAssertEqual(sut, .session)
        
        sut = QBEventType(type: "ecView")
        XCTAssertEqual(sut, .view)
        
        sut = QBEventType(type: "azView")
        XCTAssertEqual(sut, .view)
        
        sut = QBEventType(type: "trView")
        XCTAssertEqual(sut, .view)
        
        sut = QBEventType(type: "ecViewecView")
        XCTAssertEqual(sut, .other)
        
        sut = QBEventType(type: "View")
        XCTAssertEqual(sut, .other)
        
        sut = QBEventType(type: "someEvent")
        XCTAssertEqual(sut, .other)
        
        sut = QBEventType(type: "a8View")
        XCTAssertEqual(sut, .other)
        
        sut = QBEventType(type: "eeecView")
        XCTAssertEqual(sut, .other)
        
        sut = QBEventType(type: "./view")
        XCTAssertEqual(sut, .other)
    }
    
}
