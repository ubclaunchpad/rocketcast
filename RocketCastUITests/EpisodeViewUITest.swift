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
        app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        app.tables.staticTexts[SamplePodcast.podcastTitle].tap()
        let episodeCells = XCUIApplication().tables.cells
        XCTAssertEqual(2, episodeCells.count)
        XCTAssert( app.tables.staticTexts[SamplePodcast.firstEpisode].exists)
        XCTAssert( app.tables.staticTexts[SamplePodcast.secondEpisode].exists)
        
    }
    
    func testJumpToCurrentlyPlayingEpisode() {
        let app = XCUIApplication()
        let podcastsNavigationBar = app.navigationBars["Podcasts"]
        podcastsNavigationBar.buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["LaunchPad podcast testing"].tap()
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        
        let playerNavigationBar = app.navigationBars["Player"]
        playerNavigationBar.buttons["Episodes"].tap()
        app.navigationBars["Episodes"].buttons["Play"].tap()
        
        let mondayMorningPodcast91216StaticText = app.staticTexts["Monday Morning Podcast 9-12-16"]
        XCTAssert(mondayMorningPodcast91216StaticText.exists)
    }
    
    func testJumpToNextPlayingEpisode() {
        let app = XCUIApplication()
        let podcastsNavigationBar = app.navigationBars["Podcasts"]
        podcastsNavigationBar.buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["LaunchPad podcast testing"].tap()
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        app.buttons["next ep"].tap()
        app.navigationBars["Player"].buttons["Episodes"].tap()
        app.navigationBars["Episodes"].buttons["Play"].tap()
        
        let thursdayAfternoonMondayMorningPodcast9816StaticText = app.staticTexts["Thursday Afternoon Monday Morning Podcast 9-8-16"]
        XCTAssert(thursdayAfternoonMondayMorningPodcast9816StaticText.exists)
    }
    
}
