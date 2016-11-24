//
//  RocketCastUITests.swift
//  RocketCastUITests
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class EpisodeUITests: XCTestCase {

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
    
    func testTableViewCellsInEpisodeTable() {
        
        let app = XCUIApplication()
        app.buttons[AddButtonFromPodcastView].tap()
        app.buttons["Add Url"].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        let episodeCells = XCUIApplication().tables.cells
        
        XCTAssertEqual(3, episodeCells.count)
        
        let firstCell = episodeCells.element(boundBy: 1)
        XCTAssert(firstCell.staticTexts[SamplePodcast.firstEpisode].exists)
        XCTAssert(firstCell.staticTexts[tapToDownload].exists)
        
        let secondCell = episodeCells.element(boundBy: 2)
        XCTAssert(secondCell.staticTexts[SamplePodcast.secondEpisode].exists)
        XCTAssert(secondCell.staticTexts[tapToDownload].exists)
        
    }
    
    func testJumpToCurrentlyPlayingEpisodeFromEpisodeVC() {
        let app = XCUIApplication()

        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()

        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()

    
        app.buttons["Back"].tap()
        app.buttons["Play"].tap()
        
        let mondayMorningPodcast91216StaticText = app.staticTexts["Monday Morning Podcast 9-12-16"]
        XCTAssert(mondayMorningPodcast91216StaticText.exists)
    }
    
}
