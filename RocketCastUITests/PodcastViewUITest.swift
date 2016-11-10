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
            XCTAssertEqual(3, cells.count)
            let firstCell = episodeTable.cells.element(boundBy: 1)
            XCTAssert(firstCell.staticTexts[SamplePodcast.firstEpisode].exists)
            XCTAssert(firstCell.staticTexts[tapToDownload].exists)
            
            let secondCell = episodeTable.cells.element(boundBy: 2)
            XCTAssert(secondCell.staticTexts[SamplePodcast.secondEpisode].exists)
            XCTAssert(secondCell.staticTexts[tapToDownload].exists)
                    
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
    
    func testJumpToCurrentlyPlayingEpisodeFromPlayerVC() {
        let app = XCUIApplication()
        let podcastsNavigationBar = app.navigationBars["Podcasts"]
        podcastsNavigationBar.buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["LaunchPad podcast testing"].tap()
        
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        
        app.buttons["Episodes"].tap()
        app.navigationBars["Episodes"].buttons["Podcasts"].tap()
        app.navigationBars["Podcasts"].buttons["Play"].tap()
        let mondayMorningPodcast91216StaticText = app.staticTexts["Monday Morning Podcast 9-12-16"]
        XCTAssert(mondayMorningPodcast91216StaticText.exists)
    }
}
