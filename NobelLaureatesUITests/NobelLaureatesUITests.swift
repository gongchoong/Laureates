//
//  NobelLaureatesUITests.swift
//  NobelLaureatesUITests
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import XCTest

class NobelLaureatesUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
