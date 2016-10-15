//
//  RocketCastUITests.swift
//  RocketCastUITests
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class EpisodeUITests: XCTestCase {
    
    fileprivate var app = XCUIApplication()
    private var episodes = ["#845 - TJ Dillashaw, Duane Ludwig & Bas Rutten",
                    "#844 - Andreas Antonopoulos",
                    "#843 - Tony Hinchcliffe",
                    "#842 - Chris Kresser",
                    "#841 - Greg Fitzsimmons",
                    "#840 - Donald Cerrone"]
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        self.app.launch()
        sleep(1)
        
        //Test 1: Check we arrive at Home Screen
        let startScreen = self.app.staticTexts["Podcasts"]
        var exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: startScreen, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(startScreen.exists)
        XCTAssert(app.buttons["Button"].exists)
        app.buttons["Button"].tap()
        
        //Test 2: Check we arrive at Episodes Screen
        let episodeScreen = self.app.staticTexts["Episodes"]
        exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: episodeScreen, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
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
        XCTAssertEqual(cells.count,UInt(episodes.count))
        for episode in episodes {
        XCTAssert(episodeTable.staticTexts[episode].exists)

        }
        
    }
    
}
