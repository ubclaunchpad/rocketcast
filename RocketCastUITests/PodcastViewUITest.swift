//
//  PodcastViewUITest.swift
//  RocketCast
//
//  Created by James Park on 2016-10-30.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest
class PodcastViewUITest: XCTestCase {
    
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
    
    func testForDuplicatePodcastsAndEpisodes() {
        
        let app = XCUIApplication()
        var cells = XCUIApplication().tables.cells
        XCTAssertEqual(0, cells.count)
        var i = 0
        while i < 2 {
            let addButton = app.navigationBars["Podcasts"].buttons["Add"]
            addButton.tap()
            
            let addPodcastButton = app.buttons["Add Podcast"]
            addPodcastButton.tap()
            
            let launchpadPodcastTestingStaticText = app.tables.staticTexts["LaunchPad podcast testing"]
            cells = XCUIApplication().tables.cells
            XCTAssertEqual(1, cells.count)
            XCTAssert(app.staticTexts["LaunchPad podcast testing"].exists)
            
            launchpadPodcastTestingStaticText.tap()
            let episodeTable = app.tables
            cells = XCUIApplication().tables.cells
            XCTAssertEqual(2, cells.count)
            XCTAssert(episodeTable.staticTexts["Monday Morning Podcast 9-12-16"].exists)
            XCTAssert(episodeTable.staticTexts["Thursday Afternoon Monday Morning Podcast 9-8-16"].exists)
            
            app.navigationBars["Episodes"].buttons["Podcasts"].tap()
            i+=1
        }
        
    }
    
}
