//
//  XMLParserTests.swift
//  RocketCast
//
//  Created by James Park on 2016-09-11.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

import XCTest
@testable import RocketCast

class XMLParserTests: XCTestCase {
    
    let episode1:[String:String] =
        [ "title" : "Quantum Superposition",
          "description": "exploring states of particles",
          "author" : "Jon Mercer",
          "date": "Thu, 16 Jun 2005 5:00:00 PST",
          "duration" : "01:07:59",
          "image" : "JONMERCER.jpg",
          "mp3" : "http://www.yourserver.com/podcast_fileONE.mp3"]
    

    let episode2:[String:String] =
        [ "title" : "Photon",
          "description": "lights",
          "author" : "Kelvin Chan",
          "date": "Fri, 17 Jun 2005 5:00:00 PST",
          "duration" : "12:07:59",
          "image" : "KELVINCHAN.jpg",
          "mp3" : "http://www.yourserver.com/podcast_fileTWO.mp3"]
    
    var expectedEpisodes = [[String:String]]()
    
    override func setUp() {
        super.setUp()
        expectedEpisodes.append(episode1)
        expectedEpisodes.append(episode2)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseXML() {
        let xmlfilePath = NSBundle.mainBundle().URLForResource("testPodcastXML", withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        let data = NSData(contentsOfURL: NSURL(string: stringPath)!)
        var done = false
        
        ModelBridge.sharedInstance.downloadPodcastXML(data!) { (podcast) in
            done = true
            XCTAssertEqual("QuantumSpark", podcast.title)
            XCTAssertEqual("A dank podcast", podcast.description)
            XCTAssertEqual("JamesPark.jpg", podcast.imageURL)
            XCTAssertEqual(2, podcast.episodes?.count)
            
            for index in 0...(self.expectedEpisodes.count-1) {
                self.compareValues(self.expectedEpisodes[index], actualEpisode: podcast.episodes![index])
            }
            
        }
        
        waitUntil(6) {done}
        XCTAssert(done, "completeion should be called")
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        //self.measureBlock {
        // Put the code you want to measure the time of here.
        //}
    }
    
    private func waitUntil(timeout: NSTimeInterval, predicate:(Void -> Bool)) {
        let timeoutTime = NSDate(timeIntervalSinceNow: timeout).timeIntervalSinceReferenceDate
        
        while (!predicate() && NSDate.timeIntervalSinceReferenceDate() < timeoutTime) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 5))
        }
    }
    
    private func compareValues (expectedEpisode:[String:String], actualEpisode: EpisodeModel) {
        XCTAssertEqual(expectedEpisode["title"], actualEpisode.title)
        XCTAssertEqual(expectedEpisode["description"], actualEpisode.description)
        XCTAssertEqual(expectedEpisode["author"], actualEpisode.author)
        XCTAssertEqual(expectedEpisode["date"], actualEpisode.date)
        XCTAssertEqual(expectedEpisode["image"], actualEpisode.imageURL)
        XCTAssertEqual(expectedEpisode["mp3"], actualEpisode.mp3URL)
    }
    
    
}
