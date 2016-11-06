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
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["MY_UI_TEST_MODE"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testVerifyTravisBySeguing() {
        
        let app = XCUIApplication()
        app.navigationBars["Podcasts"].buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
    
        let launchpadPodcastTestingStaticText = app.tables.staticTexts[SamplePodcast.podcastTitle]
        let cells = XCUIApplication().tables.cells
        XCTAssertEqual(1, cells.count)
        XCTAssert(app.staticTexts[SamplePodcast.podcastTitle].exists)
        launchpadPodcastTestingStaticText.tap()

        let episodeCells = XCUIApplication().tables.cells
        let firstCell = episodeCells.element(boundBy: 0)
        sleep(1)
        XCTAssert(firstCell.staticTexts[SamplePodcast.firstEpisode].exists)
        XCTAssert(firstCell.staticTexts[tapToDownload].exists)
        
        let downloadingLabel = firstCell.staticTexts[downloaded]
     
        let doesntExist = NSPredicate(format: "exists == true")
        
        expectation(for: doesntExist, evaluatedWith: downloadingLabel, handler: nil)
        firstCell.tap()
        
        waitForExpectations(timeout: 50, handler: nil)
        firstCell.tap()
    
    }
    
}
