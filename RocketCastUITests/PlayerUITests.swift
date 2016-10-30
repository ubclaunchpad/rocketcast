//
//  PlayerUITests.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-10-15.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class PlayerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPlay() {
        // There are two episodes for this one podcast from AWS
        let app = XCUIApplication()

        let addButton = app.navigationBars["Podcasts"].buttons["Add"]
        addButton.tap()
        let addPodcastButton = app.buttons["Add Podcast"]
        addPodcastButton.tap()
        
        let launchpadPodcastTestingStaticText = app.tables.staticTexts["LaunchPad podcast testing"]


        launchpadPodcastTestingStaticText.tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        sleep(20)
        // Go to the first episode
        XCTAssert(app.staticTexts["Monday Morning Podcast 9-12-16"].exists)
        let playButton = app.buttons["Play"]
        playButton.tap()
        // Click on the pre-episode should do nothing because this is the first episode
        app.buttons["pre ep"].tap()
        XCTAssert(app.staticTexts["Monday Morning Podcast 9-12-16"].exists)
        let pauseButton = app.buttons["Pause"]
        pauseButton.tap()
        XCTAssert(app.staticTexts["Pause"].exists)
        // Test Fast forwarding
        playButton.tap()
        XCTAssert(app.staticTexts["Playing at 1x"].exists)
        app.buttons["2x"].tap()
        XCTAssert(app.staticTexts["Playing at 2x"].exists)
        app.buttons["3x"].tap()
        XCTAssert(app.staticTexts["Playing at 3x"].exists)
        app.buttons["1x"].tap()
        XCTAssert(app.staticTexts["Playing at 1x"].exists)
        
        // Go to the next Episode
        app.buttons["next ep"].tap()
        XCTAssert(app.staticTexts["Thursday Afternoon Monday Morning Podcast 9-8-16"].exists)
        sleep(10)
        // Click on the next episode should do nothing because this is the last episode
        app.buttons["next ep"].tap()
        XCTAssert(app.staticTexts["Thursday Afternoon Monday Morning Podcast 9-8-16"].exists)
        app.buttons["pre ep"].tap()
        XCTAssert(app.staticTexts["Monday Morning Podcast 9-12-16"].exists)
        sleep(10)
        pauseButton.tap()
    
    }
    func testSlider() {
        
        let app = XCUIApplication()
        
        let addButton = app.navigationBars["Podcasts"].buttons["Add"]
        addButton.tap()
        let addPodcastButton = app.buttons["Add Podcast"]
        addPodcastButton.tap()
        
        let launchpadPodcastTestingStaticText = app.tables.staticTexts["LaunchPad podcast testing"]
        launchpadPodcastTestingStaticText.tap()

        let tablesQuery = app.tables
        tablesQuery.staticTexts["Monday Morning Podcast 9-12-16"].tap()
        sleep(20)
        XCTAssert(app.staticTexts["Monday Morning Podcast 9-12-16"].exists)
  
        let slider = app.sliders["0%"]
        slider.adjust(toNormalizedSliderPosition: 0.99)
        sleep(20)
        XCTAssert(app.staticTexts["Thursday Afternoon Monday Morning Podcast 9-8-16"].exists)
        
    }
}
