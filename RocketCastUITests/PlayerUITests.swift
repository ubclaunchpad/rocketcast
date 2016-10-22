//
//  PlayerUITests.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-10-15.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class PlayerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPlay() {
        
        let app = XCUIApplication()
        app.buttons["Button"].tap()
        app.tables.staticTexts["Monday Morning Podcast 10-17-16"].tap()
        sleep(10)
        
        app.buttons["2x"].tap()
         XCTAssert(app.staticTexts["Playing at 2x"].exists)
        app.buttons["3x"].tap()
        XCTAssert(app.staticTexts["Playing at 3x"].exists)
        app.buttons["1x"].tap()
        XCTAssert(app.staticTexts["Playing at 1x"].exists)
        app.buttons["Pause"].tap()
        
//        let app = XCUIApplication()
//        app.buttons["Button"].tap()
//        app.tables.staticTexts["Monday Morning Podcast 10-17-16"].tap()
//        app.buttons["Play"].tap()
//        app.buttons["2x"].tap()
//        XCTAssert(app.staticTexts["Playing at 2x"].exists)
//        app.buttons["3x"].tap()
//        XCTAssert(app.staticTexts["Playing at 3x"].exists)
//        app.buttons["1x"].tap()
//        XCTAssert(app.staticTexts["Playing at 1x"].exists)
        
        //        let app = XCUIApplication()
//        let button = app.buttons["Button"]
//        button.tap()
//        button.tap()
//        app.buttons["Play"].tap()
//        
//        XCTAssert(app.staticTexts["Playing at 1x"].exists)
//        app.buttons["2x"].tap()
//        XCTAssert(app.staticTexts["Playing at 2x"].exists)
//        app.buttons["3x"].tap()
//        XCTAssert(app.staticTexts["Playing at 3x"].exists)
    }
    func testSpeed() {
        
    }
}
