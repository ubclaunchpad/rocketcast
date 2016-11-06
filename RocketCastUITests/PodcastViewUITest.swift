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
            let addButton = app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView]
            addButton.tap()
            
            let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
            addPodcastButton.tap()
            
            let launchpadPodcastTestingStaticText = app.tables.staticTexts[SamplePodcast.podcastTitle]
            cells = XCUIApplication().tables.cells
            XCTAssertEqual(1, cells.count)
            XCTAssert(app.staticTexts[SamplePodcast.podcastTitle].exists)
            launchpadPodcastTestingStaticText.tap()
            let episodeTable = app.tables
            cells = XCUIApplication().tables.cells
            XCTAssertEqual(2, cells.count)
            XCTAssert(episodeTable.staticTexts[SamplePodcast.firstEpisode].exists)
            XCTAssert(episodeTable.staticTexts[SamplePodcast.secondEpisode].exists)
            
            app.navigationBars[EpisodeButton].buttons[PodcastButton].tap()
            i+=1
        }
    }
    
    func testAddUrl() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let countBefore = tablesQuery.cells.count
        let addButton = app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView]
        addButton.tap()
        let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
        addPodcastButton.tap()
        let countAfter = tablesQuery.cells.count
        print(countBefore)
        print(countAfter)
        XCTAssert(countAfter == countBefore + 1)
    }
    
    //Assert you can segue from podcast view to player view if an episode it playing
    func testJumpBackToPlayer() {
        
        let app = XCUIApplication()
        let podcastsNavigationBar = app.navigationBars["Podcasts"]
        podcastsNavigationBar.buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["LaunchPad podcast testing"].tap()
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        
        let playerNavigationBar = app.navigationBars["Player"]
        playerNavigationBar.buttons["Episodes"].tap()
        app.navigationBars["Episodes"].buttons["Podcasts"].tap()
        
        let playButton = podcastsNavigationBar.buttons["Play"]
        playButton.tap()
        
        let mondayMorningPodcast91216StaticText = app.staticTexts["Monday Morning Podcast 9-12-16"]
        XCTAssert(mondayMorningPodcast91216StaticText.exists)
    }
    
    func testJumpBackToPlayerNextEpisode() {
        
        let app = XCUIApplication()
        let podcastsNavigationBar = app.navigationBars["Podcasts"]
        podcastsNavigationBar.buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["LaunchPad podcast testing"].tap()
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        app.buttons["next ep"].tap()
        app.navigationBars["Player"].buttons["Episodes"].tap()
        app.navigationBars["Episodes"].buttons["Podcasts"].tap()
        podcastsNavigationBar.buttons["Play"].tap()
        
        let thursdayAfternoonMondayMorningPodcast9816StaticText = app.staticTexts["Thursday Afternoon Monday Morning Podcast 9-8-16"]
        XCTAssert(thursdayAfternoonMondayMorningPodcast9816StaticText.exists)
        
        
    }
}
