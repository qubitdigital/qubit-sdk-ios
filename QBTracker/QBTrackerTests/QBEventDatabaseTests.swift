//
//  QBDatabaseTests.swift
//  QBTrackerTests
//
//  Created by Dariusz Zajac on 24/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import XCTest
@testable import QubitSDK

class QBEventDatabaseTests: XCTestCase {
    
    let databaseManager = QBDatabaseManager.shared
    let eventType: String = "TestType"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEventInsert() {
        let event = self.databaseManager.insert(entityType: QBEvent.self)

        XCTAssert(event != nil, "Error inserting event into database")

        event?.type = self.eventType
        let savedSuccessFully = self.databaseManager.save()

        XCTAssert(savedSuccessFully, "Could not save event in the database)")
    }
    
    func testEventQuery() {
        let events = self.databaseManager.query(entityType: QBEvent.self)

        XCTAssert(events.count > 0, "Error querying events")

        let event = events.first

        XCTAssert(event?.type == self.eventType, "Wrong event queried.  Event name is: \(event?.type), expecting: \(self.eventType)")
    }

    func testEventDeleteAll() {
        let success = self.databaseManager.deleteAll(from: QBEvent.self)

        XCTAssert(success, "Error deleting all events")

        let events = self.databaseManager.query(entityType: QBEvent.self)

        XCTAssert(events.count == 0, "Did not delete all events from the database, even though method returned success")
    }
    
}
