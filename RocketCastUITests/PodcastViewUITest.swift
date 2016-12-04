//
//  PodcastViewUITest.swift
//  RocketCast
//
//  Created by James Park on 2016-10-30.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest
class PodcastViewUITest: BaseUITest {
    
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
        
        for _ in 0...2 {
            let addButton = app.buttons[AddButtonFromPodcastView]
            addButton.tap()
            app.buttons["Add Url"].tap()
            let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
            addPodcastButton.tap()
            
            let launchpadPodcastTestingStaticText = app.collectionViews.staticTexts[SamplePodcast.podcastTitle]
            var cells = XCUIApplication().collectionViews.cells
            XCTAssertEqual(2, cells.count)
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
            
            app.buttons["Back"].tap()
        }
    }
    
    func testAddUrl() {
        let app = XCUIApplication()
        let tablesQuery = app.collectionViews
        let countBefore = tablesQuery.cells.count
        let addButton = app.buttons[AddButtonFromPodcastView]
        addButton.tap()
        app.buttons["Add Url"].tap()
        let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
        addPodcastButton.tap()
        let countAfter = tablesQuery.cells.count
        print(countBefore)
        print(countAfter)
        XCTAssert(countAfter == countBefore + 1)
    }
    
    func testJumpToCurrentlyPlayingEpisodeFromPlayerVC() {
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        XCTAssert(app.staticTexts[SamplePodcast.podcastTitle].exists)
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        let episodeTable = app.tables
        episodeTable.staticTexts[ SamplePodcast.firstEpisode].tap()
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        app.buttons["Play"].tap()
        XCTAssert( app.staticTexts[SamplePodcast.firstEpisode].exists)
    }
    
    func testDeletePodcast() {
        getPodcastBySeguingToUrl()
        
        let app = XCUIApplication()
        
        let collectionQuery = app.collectionViews
        let podcastTitleLabel = collectionQuery.staticTexts[SamplePodcast.podcastTitle]
        
        app.navigationBars.buttons["Delete"].tap()
        
        podcastTitleLabel.tap()
        
        app.navigationBars.buttons["Cancel"].tap()
        
        XCTAssertEqual(1, app.collectionViews.count)
        
    }
    
    func testReloadPodcast () {
        
        let app = XCUIApplication()
        
        let podcastCells = XCUIApplication().collectionViews.cells
        XCTAssertEqual(1, podcastCells.count)
        let refreshButton = app.buttons["Refresh"]
        let backButton = app.buttons["Back"]
        refreshButton.tap()
        XCTAssertEqual(1, podcastCells.count)
        getPodcastBySeguingToUrl()
        refreshButton.tap()
    
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        
        backButton.tap()
        
        refreshButton.tap()
        XCTAssertEqual(2 , podcastCells.count)
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        let tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.cells.element(boundBy: 1).staticTexts["Tap to Download"].exists)
        XCTAssertTrue(tablesQuery.cells.element(boundBy: 2).staticTexts["Tap to Download"].exists)
        
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        XCTAssertTrue(tablesQuery.cells.element(boundBy: 1).staticTexts["Downloading ..."].exists)
        
        backButton.tap()
        
        refreshButton.tap()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        
        app.staticTexts[SamplePodcast.firstEpisode].tap()
        
        backButton.tap()
        backButton.tap()
        
        refreshButton.tap()
        XCTAssertEqual(2 , podcastCells.count)
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
    }
    
    
    func testReloadPodcastsWhilePlayingPodcast () {
        
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        // please wait for awhile
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        app.tables.staticTexts[SamplePodcast.firstEpisode].tap()
        
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        
        app.buttons["Refresh"].tap()
        
    }
    
}
