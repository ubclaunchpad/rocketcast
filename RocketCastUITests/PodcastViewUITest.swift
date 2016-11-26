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
        var i = 0
        while i < 2 {
            let addButton = app.buttons[AddButtonFromPodcastView]
            addButton.tap()
            app.buttons["Add Url"].tap()
            let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
            addPodcastButton.tap()
            
            let launchpadPodcastTestingStaticText = app.collectionViews.staticTexts[SamplePodcast.podcastTitle]
            var cells = XCUIApplication().collectionViews.cells
            XCTAssertEqual(4, cells.count)
            XCTAssert(app.staticTexts[SamplePodcast.podcastTitle].exists)
            app.collectionViews.children(matching: .any).element(boundBy: 1).tap()

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
            i+=1
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
        XCTAssert(countAfter == countBefore + 2)
    }
    
    
    func testJumpToCurrentlyPlayingEpisodeFromPlayerVC() {
        let app = XCUIApplication()
        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
        
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        
        let downloadingLabel = app.staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        let episodeTable = app.tables
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        episodeTable.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        episodeTable.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        app.buttons["Play"].tap()
        let mondayMorningPodcast91216StaticText = app.staticTexts["Monday Morning Podcast 9-12-16"]
        XCTAssert(mondayMorningPodcast91216StaticText.exists)
    }
    
    func testDeletePodcast() {
        let app = XCUIApplication()
        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
        
        let collectionQuery = app.collectionViews
        let podcastTitleLabel = collectionQuery.staticTexts["LaunchPad podcast testing"]
        
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: podcastTitleLabel, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        app.navigationBars.buttons["Delete"].tap()
        
        let deleteButton = app.buttons["Delete"]
        expectation(for: doesItExist, evaluatedWith: deleteButton, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)

        deleteButton.tap()
        
        let podcastRemoved = NSPredicate(format: "count == 7")
        expectation(for: podcastRemoved, evaluatedWith: app.collectionViews.cells, handler: nil)
        print(app.collectionViews.staticTexts)
        waitForExpectations(timeout: timeOut, handler: nil)
        
    }
    
    func testReloadPodcast () {
        
        guard runForTravis else {
            return
        }
        
        let app = XCUIApplication()
    
        let podcastCells = XCUIApplication().collectionViews.cells
        XCTAssertEqual(2, podcastCells.count)
        let refreshButton = app.buttons["Refresh"]
        refreshButton.tap()
        XCTAssertEqual(1, podcastCells.count)
        
        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
        refreshButton.tap()
        
        
        app.staticTexts["LaunchPad podcast testing"].tap()
        
        let downloadingLabel = app.staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        app.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        
        app.buttons["Back"].tap()
        
        refreshButton.tap()
        XCTAssertEqual(2 , podcastCells.count)
        
        app.staticTexts["LaunchPad podcast testing"].tap()
        var tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.cells.element(boundBy: 1).staticTexts["Tap to Download"].exists)
        XCTAssertTrue(tablesQuery.cells.element(boundBy: 2).staticTexts["Tap to Download"].exists)
        
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        XCTAssertTrue(tablesQuery.cells.element(boundBy: 1).staticTexts["Downloading ..."].exists)
        
        app.buttons["Back"].tap()
        
        refreshButton.tap()
        
        app.staticTexts["LaunchPad podcast testing"].tap()
        
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        app.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        app.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        
        refreshButton.tap()
        XCTAssertEqual(2 , podcastCells.count)
        
        app.staticTexts["LaunchPad podcast testing"].tap()
    
    }
    
    
    func testReloadPodcastsWhilePlayingPodcast () {
        
        guard runForTravis else {
            return
        }
        
        let app = XCUIApplication()
        app.buttons[AddButtonFromPodcastView].tap()
        app.buttons["Add Url"].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        // please wait for awhile
        let tablesQuery = app.tables
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        
        app.buttons["Refresh"].tap()
        
    }

}
