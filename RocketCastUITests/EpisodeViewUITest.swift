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
        app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        app.tables.staticTexts[SamplePodcast.podcastTitle].tap()
        let episodeCells = XCUIApplication().tables.cells
        
        XCTAssertEqual(2, episodeCells.count)
        
        let firstCell = episodeCells.element(boundBy: 0)
        XCTAssert(firstCell.staticTexts[SamplePodcast.firstEpisode].exists)
        XCTAssert(firstCell.staticTexts[tapToDownload].exists)
        
        let secondCell = episodeCells.element(boundBy: 1)
        XCTAssert(secondCell.staticTexts[SamplePodcast.secondEpisode].exists)
        XCTAssert(secondCell.staticTexts[tapToDownload].exists)
        
    }
    
}
