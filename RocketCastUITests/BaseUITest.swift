//
//  BaseUITest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-03.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class BaseUITest: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getPodcastBySeguingToUrl() {
        let app = XCUIApplication()
        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
    }
    
    
    func clickAndDownloadEpisode(episodeTitle:String) {
        let app = XCUIApplication()
        let downloadingLabel = app.staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        let episodeTable = app.tables
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        episodeTable.staticTexts[episodeTitle].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
    }
    
}
