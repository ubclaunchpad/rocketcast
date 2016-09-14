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
    
    let normalPodcastXML = testNormalPodcastXML()
    let noEpisodesPodcastXML = testPodcastXMLWithNoEpisodes()
    let noAuthorForEpisodesPodcastXML = testPodcastNoAuthorsForEpisodes()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseNormalXML() {
        let xmlfilePath = NSBundle.mainBundle().URLForResource(normalPodcastXML.fileName, withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        let xmlParser = XMLParser(url:  stringPath)
        let acutalPodcast = xmlParser.getGeneratedPodcast()
        
        let expectedEpisodes = normalPodcastXML.expectedEpisodes
        XCTAssertEqual(normalPodcastXML.title,  acutalPodcast.title)
        XCTAssertEqual(normalPodcastXML.description, acutalPodcast.description)
        XCTAssertEqual(normalPodcastXML.imageURL, acutalPodcast.imageURL)
        XCTAssertEqual(expectedEpisodes.count, acutalPodcast.episodes.count)
        
        for index in 0...(expectedEpisodes.count-1) {
            compareEpisode(expectedEpisodes[index], actualEpisode: acutalPodcast.episodes[index])
        }
    }
    
    func testParseXMLWithNoEpisodes() {
        let xmlfilePath = NSBundle.mainBundle().URLForResource(noEpisodesPodcastXML.fileName, withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        let xmlParser = XMLParser(url: stringPath)
        let acutalPodcast = xmlParser.getGeneratedPodcast()
        
        XCTAssertEqual(noEpisodesPodcastXML.title,  acutalPodcast.title)
        XCTAssertEqual(noEpisodesPodcastXML.description, acutalPodcast.description)
        XCTAssertEqual(noEpisodesPodcastXML.imageURL, acutalPodcast.imageURL)
        XCTAssertEqual(0, acutalPodcast.episodes.count)
    }
    
    
    func testParseXMLWithNoAuthorsInEpisodes() {
        let xmlfilePath = NSBundle.mainBundle().URLForResource(noAuthorForEpisodesPodcastXML.fileName, withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        let xmlParser = XMLParser(url: stringPath)
        let acutalPodcast = xmlParser.getGeneratedPodcast()
        
        let expectedEpisodes = noAuthorForEpisodesPodcastXML.expectedEpisodes
        XCTAssertEqual(noAuthorForEpisodesPodcastXML.title,  acutalPodcast.title)
        XCTAssertEqual(noAuthorForEpisodesPodcastXML.description, acutalPodcast.description)
        XCTAssertEqual(noAuthorForEpisodesPodcastXML.imageURL, acutalPodcast.imageURL)
        XCTAssertEqual(expectedEpisodes.count, acutalPodcast.episodes.count)
        
        for index in 0...(expectedEpisodes.count-1) {
            compareEpisode(expectedEpisodes[index], actualEpisode: acutalPodcast.episodes[index])
        }
    }
    


    func testPerformanceExample() {
        // This is an example of a performance test case.
        //self.measureBlock {
        // Put the code you want to measure the time of here.
        //}
    }
    

    private func compareEpisode (expectedEpisode:[String:String], actualEpisode: EpisodeModel) {
        XCTAssertEqual(expectedEpisode["title"], actualEpisode.title)
        XCTAssertEqual(expectedEpisode["description"], actualEpisode.description)
        XCTAssertEqual(expectedEpisode["author"], actualEpisode.author)
        XCTAssertEqual(expectedEpisode["date"], actualEpisode.date)
        XCTAssertEqual(expectedEpisode["image"], actualEpisode.imageURL)
        XCTAssertEqual(expectedEpisode["mp3"], actualEpisode.mp3URL)
    }
    
    
}
