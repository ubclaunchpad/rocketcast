//
//  RocketCastUITests.swift
//  RocketCastUITests
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class EpisodeUITests: XCTestCase {
    
    private var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        self.app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        
        //Test 1: Check we arrive at Home Screen
        let startScreen = self.app.staticTexts["Podcast"]
        let exists = NSPredicate(format: "exists == true")
        expectationForPredicate(exists, evaluatedWithObject: startScreen, handler: nil)
        
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssert(startScreen.exists)
        
        //Test 2: Check we arrive at Episodes Screen
        let episodeScreen = self.app.staticTexts["Episodes"]
        expectationForPredicate(exists, evaluatedWithObject: startScreen, handler: nil)
        app.buttons["Button"].tap()
        waitForExpectationsWithTimeout(5, handler: nil)
        
        XCTAssert(episodeScreen.exists)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTableViewCells() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let episodeTable = self.app.tables
        
        let cells = episodeTable.cells
        XCTAssertEqual(cells.count, 3, "found instead: \(cells.debugDescription)")

        XCTAssert(episodeTable.staticTexts["How to Cook Podcast"].exists)
        XCTAssert(episodeTable.staticTexts["NodeJS Development Podcast"].exists)
        XCTAssert(episodeTable.staticTexts["iOS Development Podcastaeuoaeuoaeuoateoetnoetnotneotneotneotntneoeotnetnotneotneotneotneotneotneotnetnoetnoetnoetno"].exists)
        
    }
    
}
