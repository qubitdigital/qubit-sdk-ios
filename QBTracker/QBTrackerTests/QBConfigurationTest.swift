//
//  QBConfigurationTest.swift
//  QBTrackerTests
//
//  Created by Pavlo Davydiuk on 21/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import XCTest
@testable import QubitSDK

class QBConfigurationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDownloadConfigurationWithCorrrectId() {
        weak var expectation = self.expectation(description: "Download configuration")
        
        defaultConfigurationService.getConfigution(forId: "roeld") { result in
            switch result {
            case .success(let config):
                print("config = \(config) \n")
                XCTAssert(true)
            case .failure(let error):
                print("error = \(error) \n")
                XCTAssert(false, error.localizedDescription)
            }
            
            expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testDownloadConfigurationWithWrongId() {
        weak var expectation = self.expectation(description: "Download configuration")
        
        defaultConfigurationService.getConfigution(forId: "qubit_test_123") { result in
            switch result {
            case .success(let config):
                print("config = \(config) \n")
                XCTAssert(false, "Id is wrong, should be return error")
            case .failure(let error):
                print("error = \(error) \n")
                XCTAssert(true)
            }
            
            expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }

}
