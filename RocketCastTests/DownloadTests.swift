//
//  DownloadTests.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest
@testable import RocketCast

class DownloadTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDownloadPodcastXML() {
        // Test real podcasts
        var done = false
        let url = "http://billburr.libsyn.com/rss"
        let fileMgr = NSFileManager.defaultManager()
        
        ModelBridge.sharedInstance.downloadPodcastXML(url) { (downloadedPodcast) in
            done = true
            
            XCTAssertNotNil(downloadedPodcast)
            
            let path = NSHomeDirectory().stringByAppendingString(downloadedPodcast!)
            
            if let data = fileMgr.contentsAtPath(path) {
                let xmlString = String(data:data, encoding: NSUTF8StringEncoding)!
                Log.info(xmlString)
                XCTAssertTrue(xmlString.containsString("xml") && xmlString.containsString("xml"))
            }
        }
        let url2 = "http://www.npr.org/rss/podcast.php?id=510298"
        
        ModelBridge.sharedInstance.downloadPodcastXML(url2) { (downloadedPodcast) in
            done = true
            
            XCTAssertNotNil(downloadedPodcast)
            
            let path = NSHomeDirectory().stringByAppendingString(downloadedPodcast!)
            
            if let data = fileMgr.contentsAtPath(path) {
                let xmlString = String(data:data, encoding: NSUTF8StringEncoding)!
                Log.info(xmlString)
                XCTAssertTrue(xmlString.containsString("xml") && xmlString.containsString("xml"))
            }
        }
        
        waitUntil(6) {done}
    }
    
    func testDownloadRandomString() {
        // Testing a random string
        var done = false
        let url = "fawefwefaw"
        let fileMgr = NSFileManager.defaultManager()
        
        ModelBridge.sharedInstance.downloadPodcastXML(url) { (downloadedPodcast) in
            done = true
            XCTAssertNil(downloadedPodcast)
        }
        
        waitUntil(6) {done}
    }
    
    func testDownloadNonPodcastLinkXML() {
        // Testing a random non podcast link
        var done = false
        let url = "http://www.google.ca/"
        let fileMgr = NSFileManager.defaultManager()
        
        ModelBridge.sharedInstance.downloadPodcastXML(url) { (downloadedPodcast) in
            done = true
            XCTAssertNil(downloadedPodcast)
        }
        
        waitUntil(6) {done}
    }
    
    private func waitUntil(timeout: NSTimeInterval, predicate:(Void -> Bool)) {
        let timeoutTime = NSDate(timeIntervalSinceNow: timeout).timeIntervalSinceReferenceDate
        
        while (!predicate() && NSDate.timeIntervalSinceReferenceDate() < timeoutTime) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 5))
        }
    }
}
