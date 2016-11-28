//
//  ItuneWebUITests.swift
//  RocketCast
//
//  Created by James Park on 2016-11-26.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class ItuneWebUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["MY_UI_TEST_MODE"]
        app.launch()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testItuneAPI() {
        let app = XCUIApplication()
        app.buttons[AddButtonFromPodcastView].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element.tap()
        
        let lookForAPodcastSearchField = app.searchFields["Look for a podcast"]
        lookForAPodcastSearchField.tap()
        lookForAPodcastSearchField.typeText("Monday Morning")
        sleep(1)
        app.staticTexts["Monday Morning Podcast"].tap()
        
        XCTAssertTrue(app.staticTexts["Monday Morning Podcast"].exists)
    }
    
}
