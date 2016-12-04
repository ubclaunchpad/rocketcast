//
//  RocketCastUITests.swift
//  RocketCastUITests
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class RocketCastUITests: BaseUITest {
    
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
        getPodcastBySeguingToUrl()
        XCTAssert(app.staticTexts[SamplePodcast.podcastTitle].exists)
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        let episodeCells = XCUIApplication().tables.cells
        let firstCell = episodeCells.element(boundBy: 1)
        sleep(1)
        XCTAssert(firstCell.staticTexts[tapToDownload].exists)
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        firstCell.tap()
    
    }
    
}
