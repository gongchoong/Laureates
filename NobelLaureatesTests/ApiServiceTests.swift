//
//  ApiServiceTests.swift
//  NobelLaureatesTests
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import XCTest
@testable import NobelLaureates

class ApiServiceTests: XCTestCase {

    var sut: ApiService?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ApiService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testfetchNobelPrizeData(){
        //Given
        guard let sut = sut else {return}
        
        //When
        let expect = XCTestExpectation(description: "fetch complete")
        sut.fetchNobelPrizeData { (success, laureates, error) in
            if success{
                expect.fulfill()
            }
            for laureate in laureates{
                XCTAssertNotNil(laureate.firstName)
                XCTAssertNotNil(laureate.lastName)
                XCTAssertNotNil(laureate.city)
                XCTAssertNotNil(laureate.location)
                XCTAssertNotNil(laureate.year)
            }
            XCTAssertEqual(laureates.count, 436)
        }
        
        wait(for: [expect], timeout: 3.0)
    }

}
