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
        XCTAssert(countAfter == countBefore + 1)
    }
    
    func testReloadPodcast() {
        // TODO: 
        // do asserts later
        let app = XCUIApplication()
        let podcastsNavigationBar = app.navigationBars["Podcasts"]
        let refreshButton = podcastsNavigationBar.buttons["Refresh"]
        refreshButton.tap()
        podcastsNavigationBar.buttons["Add"].tap()
        app.buttons["Add Podcast"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["LaunchPad podcast testing"].tap()
        
        let mondayMorningPodcast91216StaticText = tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"]
        mondayMorningPodcast91216StaticText.tap()
        app.navigationBars["Player"].buttons["Episodes"].tap()
        app.navigationBars["Episodes"].buttons["Podcasts"].tap()
        refreshButton.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tables.staticTexts["Bill Burr rants about relationship advice, sports and the Illuminati."].tap()
        mondayMorningPodcast91216StaticText.tap()
        
    }
}
