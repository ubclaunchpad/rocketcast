//
//  RocketCastUITests.swift
//  RocketCastUITests
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest

class RocketCastUITests: XCTestCase {
    
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
        
        let app = XCUIApplication()
        app.buttons["Add"].tap()
        app.buttons["Add Url"].tap()
        app.buttons["Add Podcast"].tap()
        
        XCTAssert(app.staticTexts[SamplePodcast.podcastTitle].exists)
        app.collectionViews.children(matching: .any).element(boundBy: 1).tap()

        let episodeCells = XCUIApplication().tables.cells
        print(episodeCells.count)
        let firstCell = episodeCells.element(boundBy: 1)
        print(firstCell)
        sleep(1)
        XCTAssert(firstCell.staticTexts[tapToDownload].exists)
        
        let downloadingLabel = firstCell.staticTexts[downloaded]
     
        let doesntExist = NSPredicate(format: "exists == true")
        
        expectation(for: doesntExist, evaluatedWith: downloadingLabel, handler: nil)
        firstCell.tap()
        
        waitForExpectations(timeout: timeOut, handler: nil)
        firstCell.tap()
    
    }
    
}
