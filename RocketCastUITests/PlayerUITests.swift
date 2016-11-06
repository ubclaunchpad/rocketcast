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
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["MY_UI_TEST_MODE"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSpeedRate () {
        
        let app = XCUIApplication()
        app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        let tablesQuery = app.tables
    
        tablesQuery.staticTexts[SamplePodcast.podcastTitle].tap()
         // please wait for awhile
        let downloadingLabel = tablesQuery.cells.element(boundBy: 0).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: 50, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()

        
        // Verify if the slider is moving
        let initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        let normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        let normalSliderPositionDiff = normalSliderPositionValue - initialSliderPositionValue
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
        
        // Verify if 2x speed is working (i.e the slider should move faster)
        app.buttons[play2TimesButton].tap()
        sleep(1)
        let twoTimesSliderPositionValue = app.sliders.element.normalizedSliderPosition
        let twoTimesSliderPositionDiff = twoTimesSliderPositionValue - initialSliderPositionValue
        XCTAssertTrue(twoTimesSliderPositionDiff > normalSliderPositionDiff)
        
        // Verify if 3x speed is working (i.e the slider should move the fastest)
        app.buttons[play3TimesButton].tap()
        sleep(1)
        let threeTimeSliderPositionValue = app.sliders.element.normalizedSliderPosition
        let threeTimesSliderPositionDiff = threeTimeSliderPositionValue - initialSliderPositionValue
        XCTAssertTrue(threeTimesSliderPositionDiff > normalSliderPositionDiff)
        XCTAssertTrue(threeTimesSliderPositionDiff > twoTimesSliderPositionDiff)
        
        // Verify if the pause button is working (i.e the slider should not move)
        app.buttons[pauseButton].tap()
        let currentSliderValue = app.sliders.element.normalizedSliderPosition
        sleep(2)
        XCTAssertTrue(currentSliderValue == app.sliders.element.normalizedSliderPosition)
    }
    
    func testIfSliderIsMoving () {
        
        let app = XCUIApplication()
        app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.podcastTitle].tap()
        
        let mondayMorningPodcast91216StaticText = tablesQuery.staticTexts[SamplePodcast.firstEpisode]
        // please wait for awhile
        let downloadingLabel = tablesQuery.cells.element(boundBy: 0).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        mondayMorningPodcast91216StaticText.tap()
        waitForExpectations(timeout: 50, handler: nil)
        mondayMorningPodcast91216StaticText.tap()
        
        
        let initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        let normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        // Verify if the slider is moving
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
        app.buttons[pauseButton].tap()
    
    }
    
    func testVerifyIfNextEpisodeIsPlayedWhenSliderReachesNearMaxValue() {
        
        let app = XCUIApplication()
        let addButton = app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView]
        addButton.tap()
        let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
        addPodcastButton.tap()
        
        let launchpadPodcastTestingStaticText = app.tables.staticTexts[SamplePodcast.podcastTitle]
        launchpadPodcastTestingStaticText.tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        // Go to the first episode
        let downloadingLabel = tablesQuery.cells.element(boundBy: 0).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: 50, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()

        XCTAssert(app.staticTexts[SamplePodcast.firstEpisode].exists)
        var initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        var normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
        
        // move the slider to the end, which should go to the next episode
        app.sliders.element.adjust(toNormalizedSliderPosition: 0.99)
        let successAlert = app.alerts["Success"]
        XCTAssertFalse(successAlert.exists)
        
        expectation(for: doesItExist, evaluatedWith: successAlert, handler: nil)
        waitForExpectations(timeout: 50, handler: nil)
         successAlert.buttons["Ok"].tap()
        XCTAssert(app.staticTexts[SamplePodcast.secondEpisode].exists)
        initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
    }

}
