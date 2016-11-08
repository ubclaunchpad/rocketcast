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
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
         // please wait for awhile
        sleep(10)
        
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
        mondayMorningPodcast91216StaticText.tap()
        // please wait for awhile
        sleep(10)
        var initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        var normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        // Verify if the slider is moving
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
        app.buttons[pauseButton].tap()
        
        // Go to the next episode
        app.buttons[playNextEpisodeButton].tap()
        XCTAssert(app.staticTexts[SamplePodcast.secondEpisode].exists)
        sleep(10)
        initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        // Verify if the slider is moving
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
        app.buttons[pauseButton].tap()

        // Go the episode viewcontroler
        let episodesButton = app.navigationBars[PlayerButton].buttons[EpisodeButton]
        episodesButton.tap()
        // Go back to the first episode
        mondayMorningPodcast91216StaticText.tap()
        sleep(1)
        initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(2)
        normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
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
        sleep(10)
        XCTAssert(app.staticTexts[SamplePodcast.firstEpisode].exists)
        var initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        var normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
        
        // move the slider to the end, which should go to the next episode
        app.sliders.element.adjust(toNormalizedSliderPosition: 0.99)
        sleep(10)
        XCTAssert(app.staticTexts[SamplePodcast.secondEpisode].exists)
        initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
        sleep(1)
        normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
    }
    
    func testNextAndPreEpisode() {
        // There are only two episodes from the AWS
        let app = XCUIApplication()
        app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.podcastTitle].tap()
        // Go to the first episode
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        sleep(10)
        var i = 0
        while (i < 2) {
            XCTAssert(app.staticTexts[SamplePodcast.firstEpisode].exists)
            
            // Check edge case (the is the first episode)
            let preEpButton = app.buttons[playPrevEpisodeButton]
            preEpButton.tap()
            var initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
            sleep(1)
            var normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
            XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
            
            // Go to the next episode
            let nextEpButton = app.buttons[playNextEpisodeButton]
            nextEpButton.tap()
            sleep(10)
            XCTAssert(app.staticTexts[SamplePodcast.secondEpisode].exists)
            initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
            sleep(1)
            normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
            XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
            
            // Check edge case (this is the last episode)
            nextEpButton.tap()
            
            // Go back to the first episode
            preEpButton.tap()
            sleep(4)
            XCTAssert(app.staticTexts[SamplePodcast.firstEpisode].exists)
            initialSliderPositionValue = app.sliders.element.normalizedSliderPosition
            sleep(1)
            normalSliderPositionValue = app.sliders.element.normalizedSliderPosition
            XCTAssertTrue(normalSliderPositionValue > initialSliderPositionValue)
            i+=1
        }
    }
    
    func testSkipAndRevertButton() {
        let app = XCUIApplication()
        app.navigationBars[PodcastButton].buttons[AddButtonFromPodcastView].tap()
        app.buttons[AddPodcastButtonOnAddURLView].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[SamplePodcast.podcastTitle].tap()
        // Go to the first episode
        tablesQuery.staticTexts[SamplePodcast.firstEpisode].tap()
        sleep(10)
        let beforeSkipSliderPos = app.sliders.element.normalizedSliderPosition
        app.buttons[skipButton].tap()
        let afterSkipSliderPos = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(beforeSkipSliderPos < afterSkipSliderPos)
        
        let beforeRevertSliderPos = app.sliders.element.normalizedSliderPosition
        app.buttons[backButton].tap()
        let afterRevertSliderPos = app.sliders.element.normalizedSliderPosition
        XCTAssertTrue(beforeRevertSliderPos > afterRevertSliderPos)
        
        
    }
}
