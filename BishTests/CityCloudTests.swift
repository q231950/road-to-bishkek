//
//  CityCloudTests.swift
//  CityCloudTests
//
//  Created by Martin Kim Dung-Pham on 16.06.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import XCTest
import Bish

class CityCloudTests: XCTestCase {
    
    let cityCloudUnderTest = CityCloud()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCityCloudHasCities() {
        let expectation = self.expectation(description: "fetch complete")
        try! cityCloudUnderTest.cities({ (cities) in
            XCTAssert(cities.count != 0, "there should be cities")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
