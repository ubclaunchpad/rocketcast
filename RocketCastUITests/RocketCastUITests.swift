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

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testSegueToViews() {
        let startScreen = self.app.staticTexts["Podcast"]
        var exists = NSPredicate(format: "exists == true")
        
        //Test 1: Check we arrive at Home Screen
        expectationForPredicate(exists, evaluatedWithObject: startScreen, handler: nil)
        
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(startScreen.exists)
        self.app.buttons["Button"].tap()
        
        //Test 2: Check we arrive at Episodes Screen
        let episodesScreen = self.app.staticTexts["Episodes"]
        exists = NSPredicate(format: "exists == true")
        
        expectationForPredicate(exists, evaluatedWithObject: episodesScreen, handler: nil)

        waitForExpectationsWithTimeout(5, handler: nil)
        
        XCTAssert(episodesScreen.exists)

        //Test 3: Check we arrive at End Screen
        let notExists = NSPredicate(format: "exists == false")
        
        expectationForPredicate(notExists, evaluatedWithObject: episodesScreen, handler: nil)
        self.app.buttons["Button"].tap()
        waitForExpectationsWithTimeout(5, handler: nil)
        
        XCTAssert(!episodesScreen.exists)
    }

    
}
