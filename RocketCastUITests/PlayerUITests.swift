//
//  PlayerUITests.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-10-15.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest
import CoreGraphics

class PlayerUITests: BaseUITest {
    
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
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        // please wait for awhile
    
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        app.tables.staticTexts[SamplePodcast.firstEpisode].tap()
        
        let doesItExist = NSPredicate(format: "exists == true")
        let slider = app.sliders["0%"]
        expectation(for: doesItExist, evaluatedWith: slider, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        // Verify if the slider is moving
        
        var normalSliderPositionValue =  app.sliders["1%"]
        XCTAssertFalse(normalSliderPositionValue.exists)
        expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        
        // Verify if 2x speed is working (i.e the slider should move faster)
        app.buttons[play2TimesButton].tap()
        
        normalSliderPositionValue =  app.sliders["3%"]
        XCTAssertFalse(normalSliderPositionValue.exists)
        expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        
        // Verify if 3x speed is working (i.e the slider should move the fastest)
        app.buttons[play3TimesButton].tap()
        
        normalSliderPositionValue =  app.sliders["4%"]
        XCTAssertFalse(normalSliderPositionValue.exists)
        expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        // Verify if the pause button is working (i.e the slider should not move)
        app.buttons[pauseButton].tap()
        let currentSliderValue = app.sliders.element.normalizedSliderPosition
        sleep(2)
        XCTAssertTrue(currentSliderValue == app.sliders.element.normalizedSliderPosition)
    }
    
    func testIfSliderIsMoving () {
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
        let tablesQuery = app.tables
        let mondayMorningPodcast91216StaticText = tablesQuery.staticTexts[SamplePodcast.firstEpisode]
        // please wait for awhile
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        mondayMorningPodcast91216StaticText.tap()
    
        let normalSliderPositionValue =  app.sliders["1%"]
        XCTAssertFalse(normalSliderPositionValue.exists)
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: normalSliderPositionValue, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        
        app.buttons[pauseButton].tap()
    }
    
    func testVerifyIfNextEpisodeIsPlayedWhenSliderReachesNearMaxValue() {
        
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        let mondayMorningPodcast91216StaticText = tablesQuery.staticTexts[SamplePodcast.firstEpisode]
        // Go to the first episode
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        mondayMorningPodcast91216StaticText.tap()
        
        XCTAssert(app.staticTexts[SamplePodcast.firstEpisode].exists)
        let doesItExist = NSPredicate(format: "exists == true")
        let normalSliderPositionValue =  app.sliders["1%"]
        XCTAssertFalse(normalSliderPositionValue.exists)
        expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        // move the slider to the end, which should go to the next episode
        app.sliders.element.adjust(toNormalizedSliderPosition: 0.99)
        let successAlert = app.alerts["Success"]
        XCTAssertFalse(successAlert.exists)
        expectation(for: doesItExist, evaluatedWith: successAlert, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        successAlert.buttons["Ok"].tap()
        XCTAssert(app.staticTexts[SamplePodcast.secondEpisode].exists)
        XCTAssertFalse(normalSliderPositionValue.exists)
        expectation(for: doesItExist, evaluatedWith: normalSliderPositionValue, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
    }
    
    func testSpeedRateButtonIsSaved() {
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
    
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        // Go to the first episode
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        app.staticTexts[SamplePodcast.firstEpisode].tap()
        
        XCTAssert(app.buttons[play2TimesButton].exists)
        app.buttons[play2TimesButton].tap()
        XCTAssert(app.buttons[play3TimesButton].exists)
        
        app.buttons["Back"].tap()
        app.buttons[PlayButtonFromNavigationBar].tap()
        
        XCTAssert(app.buttons[play3TimesButton].exists)
        
        app.buttons["Back"].tap()
    }
    
    func testSkipAndRevertButton() {
        
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        app.tables.staticTexts[SamplePodcast.firstEpisode].tap()
        
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
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: successAlert, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        successAlert.buttons["Ok"].tap()
        
    }
    
    func testDeletion () {
        getPodcastBySeguingToUrl()
        let app = XCUIApplication()
        
        app.staticTexts[SamplePodcast.podcastTitle].tap()
        // please wait for awhile
    
        clickAndDownloadEpisode(episodeTitle: SamplePodcast.firstEpisode)
        app.tables.staticTexts[SamplePodcast.firstEpisode].tap()
        
        // Click Delete button
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["Trash"].tap()
        app.alerts["Delete Episode"].buttons["Delete"].tap()
        
        
        let podcastText = app.staticTexts[SamplePodcast.podcastTitle]
        
        
        //Verify that we have been redirected to Episodes View
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: podcastText, handler: nil)
        waitForExpectations(timeout: timeOut, handler: nil)
        
        let episodeCells = XCUIApplication().tables.cells
        
        XCTAssertEqual(3, episodeCells.count)
        
        //Verify that episodes have been deleted
        let firstCell = episodeCells.element(boundBy: 1)
        XCTAssertTrue(firstCell.staticTexts[SamplePodcast.firstEpisode].exists)
        XCTAssertFalse(firstCell.staticTexts[tapToDownload].exists)
        
        let secondCell = episodeCells.element(boundBy: 2)
        XCTAssertTrue(secondCell.staticTexts[SamplePodcast.secondEpisode].exists)
        XCTAssertTrue(secondCell.staticTexts[tapToDownload].exists)
    }
    
}
