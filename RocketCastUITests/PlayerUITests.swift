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
        app.buttons[AddButtonFromPodcastView].tap()
        app.buttons["Add Url"].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        // please wait for awhile
        let tablesQuery = app.tables
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        
        
        let slider = app.sliders["0%"]
        expectation(for: doesItExist, evaluatedWith: slider, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        // Verify if the slider is moving
        if (runForTravis) {
            let normalSliderPositionValue =  app.sliders["1%"]
            XCTAssertFalse(normalSliderPositionValue.exists)
            expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
            waitForExpectations(timeout: timeOut, handler: nil)
        }
        
        // Verify if 2x speed is working (i.e the slider should move faster)
        app.buttons[play2TimesButton].tap()
        if (runForTravis) {
            let normalSliderPositionValue =  app.sliders["3%"]
            XCTAssertFalse(normalSliderPositionValue.exists)
            expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
            waitForExpectations(timeout: timeOut, handler: nil)
        }
        
        // Verify if 3x speed is working (i.e the slider should move the fastest)
        app.buttons[play3TimesButton].tap()
        if (runForTravis) {
            let normalSliderPositionValue =  app.sliders["5%"]
            XCTAssertFalse(normalSliderPositionValue.exists)
            expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
            waitForExpectations(timeout: timeOut, handler: nil)
        }
        // Verify if the pause button is working (i.e the slider should not move)
        app.buttons[pauseButton].tap()
        let currentSliderValue = app.sliders.element.normalizedSliderPosition
        sleep(2)
        XCTAssertTrue(currentSliderValue == app.sliders.element.normalizedSliderPosition)
    }
    
    func testIfSliderIsMoving () {
        
        let app = XCUIApplication()
        app.buttons[AddButtonFromPodcastView].tap()
        app.buttons["Add Url"].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        
        let tablesQuery = app.tables
        let mondayMorningPodcast91216StaticText = tablesQuery.staticTexts[SamplePodcast.firstEpisode]
        // please wait for awhile
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        mondayMorningPodcast91216StaticText.tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        mondayMorningPodcast91216StaticText.tap()
        
        if (runForTravis) {
            let normalSliderPositionValue =  app.sliders["1%"]
            XCTAssertFalse(normalSliderPositionValue.exists)
            expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
            waitForExpectations(timeout: timeOut, handler: nil)
        }
        
        app.buttons[pauseButton].tap()
    }
    
    func testVerifyIfNextEpisodeIsPlayedWhenSliderReachesNearMaxValue() {
        
        guard runForTravis else {
            return
        }
        
        let app = XCUIApplication()
        app.buttons[AddButtonFromPodcastView].tap()
        app.buttons["Add Url"].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        // Go to the first episode
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        
        XCTAssert(app.staticTexts[SamplePodcast.firstEpisode].exists)
        if (runForTravis) {
            let normalSliderPositionValue =  app.sliders["1%"]
            XCTAssertFalse(normalSliderPositionValue.exists)
            expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
            waitForExpectations(timeout: timeOut, handler: nil)
        }
        // move the slider to the end, which should go to the next episode
        app.sliders.element.adjust(toNormalizedSliderPosition: 0.99)
        let successAlert = app.alerts["Success"]
        XCTAssertFalse(successAlert.exists)
        expectation(for: doesItExist, evaluatedWith: successAlert, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        successAlert.buttons["Ok"].tap()
        XCTAssert(app.staticTexts[SamplePodcast.secondEpisode].exists)
        if (runForTravis) {
            let normalSliderPositionValue =  app.sliders["1%"]
            XCTAssertFalse(normalSliderPositionValue.exists)
            expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
            waitForExpectations(timeout: timeOut, handler: nil)
        }
    }
    
    func testSpeedRateButtonIsSaved() {
        let app = XCUIApplication()
        app.buttons[AddButtonFromPodcastView].tap()
        app.buttons["Add Url"].tap()
        let addPodcastButton = app.buttons[AddPodcastButtonOnAddURLView]
        addPodcastButton.tap()
        
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        // Go to the first episode
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        app.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        app.staticTexts[SamplePodcast.firstEpisode].tap()
        
        XCTAssert(app.buttons[play2TimesButton].exists)
        app.buttons[play2TimesButton].tap()
        XCTAssert(app.buttons[play3TimesButton].exists)
        
        app.buttons["Back"].tap()
        let playButton = app.buttons[PlayButtonFromNavigationBar]
        playButton.tap()
        
        XCTAssert(app.buttons[play3TimesButton].exists)
        
        app.buttons["Back"].tap()
    }
    
    func testSkipAndRevertButton() {
        
        guard runForTravis else {
            return
        }

        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()
        
        let downloadingLabel = tablesQuery.cells.element(boundBy: 1).staticTexts[downloaded]
        let doesItExist = NSPredicate(format: "exists == true")
        expectation(for: doesItExist, evaluatedWith: downloadingLabel, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        waitForExpectations(timeout: timeOut, handler: nil)
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        
        let beforeSkipSliderPos = app.sliders.element.normalizedSliderPosition
        app.buttons[skipButton].tap()
        let afterSkipSliderPos = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(beforeSkipSliderPos < afterSkipSliderPos)
        
        app.sliders.element.adjust(toNormalizedSliderPosition: 0.40)
        let beforeRevertSliderPos = app.sliders.element.normalizedSliderPosition
        app.buttons[backButton].tap()
        app.buttons[backButton].tap()
        app.buttons[backButton].tap()
        let afterRevertSliderPos = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(beforeRevertSliderPos > afterRevertSliderPos)

        // Go to near the end
        
        app.sliders.element.adjust(toNormalizedSliderPosition: 0.98)
        app.buttons[skipButton].tap()
        
        let successAlert = app.alerts["Success"]
        XCTAssertFalse(successAlert.exists)
        expectation(for: doesItExist, evaluatedWith: successAlert, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        successAlert.buttons["Ok"].tap()

    }
    
}
