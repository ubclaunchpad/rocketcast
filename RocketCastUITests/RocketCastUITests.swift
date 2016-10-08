//
//  RocketCastUITests.swift
//  RocketCastUITests
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class RocketCastUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        self.app.launch()
        sleep(2)

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testSegueToViews() {
        
        //Test 1: Check we arrive at Home Screen
        let startScreen = app.staticTexts["Podcasts"]
        let button = app.buttons["Button"]
        let exists = NSPredicate(format: "exists == true")
        
        expectationForPredicate(exists, evaluatedWithObject: startScreen, handler: nil)
        waitForExpectationsWithTimeout(20, handler: nil)
        
        XCTAssert(startScreen.exists)
        XCTAssert(app.buttons["Button"].exists)
        
        //Go to next screen
        app.buttons["Button"].tap()
        
        //Test 2: Check we arrive at Episodes Screen
        let episodeScreen = self.app.staticTexts["Episodes"]
        
        expectationForPredicate(exists, evaluatedWithObject: episodeScreen, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        
        XCTAssert(episodeScreen.exists)
        
        //Test 3: Check we arrive at End Screen
        let notExists = NSPredicate(format: "exists == false")
        
        expectationForPredicate(notExists, evaluatedWithObject: episodeScreen, handler: nil)
        self.app.buttons["Button"].tap()
        waitForExpectationsWithTimeout(10, handler: nil)
        
        XCTAssert(!episodeScreen.exists)
    }

    
}
