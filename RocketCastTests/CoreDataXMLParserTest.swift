//
//  CoreDataXMLParserTest.swift
//  RocketCast
//
//  Created by James Park on 2016-09-24.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest
import CoreData
@testable import RocketCast
class CoreDataXMLParserTest: XCTestCase {
    
    
    let normalPodcastXML = testNormalPodcastXML()
    let noEpisodesPodcastXML = testPodcastXMLWithNoEpisodes()
    let noAuthorForEpisodesPodcastXML = testPodcastNoAuthorsForEpisodes()
    
    
    override func setUp() {
        super.setUp()
        DatabaseController.deleteAllManagedObjects()
    }
    
    func testParseNormalXML() {
        let xmlfilePath = Bundle.main.url(forResource: normalPodcastXML.fileName, withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        _ = RocketCast.XMLParser(url:  stringPath)
        let podcast = DatabaseController.getPodcast(byTitle: normalPodcastXML.title)
        let expectedEpisodes = normalPodcastXML.expectedEpisodes
        XCTAssertEqual(self.normalPodcastXML.title,  podcast.title)
        XCTAssertEqual(self.normalPodcastXML.description, podcast.summary)
        XCTAssertEqual(self.normalPodcastXML.imageURL, podcast.imageURL)
        XCTAssertEqual(expectedEpisodes.count, podcast.episodes?.count)
        let episodes = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
        var index = 0
        for episode in episodes {
            self.compareValues(episode, expectedEpisode: expectedEpisodes[index])
            index  = index + 1
        }
    
    }

  func testParseXMLNoAuthorsForEpisodes() {
        let xmlfilePath = Bundle.main.url(forResource: noAuthorForEpisodesPodcastXML.fileName, withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        _ = RocketCast.XMLParser(url:  stringPath)
        let podcast = DatabaseController.getPodcast(byTitle: noAuthorForEpisodesPodcastXML.title)
        let expectedEpisodes = noAuthorForEpisodesPodcastXML.expectedEpisodes
        
        XCTAssertEqual(self.noAuthorForEpisodesPodcastXML.title,  podcast.title)
        XCTAssertEqual(self.noAuthorForEpisodesPodcastXML.description, podcast.summary)
        XCTAssertEqual(self.noAuthorForEpisodesPodcastXML.imageURL, podcast.imageURL)
        XCTAssertEqual(expectedEpisodes.count, podcast.episodes?.count)
        let episodes = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
        
        var index = 0
        for episode in episodes {
            self.compareValues(episode, expectedEpisode: expectedEpisodes[index])
            index  = index + 1
        }
    }
    
    
    func testParseXMLWithNoEpisodes() {
        let xmlfilePath = Bundle.main.url(forResource: noEpisodesPodcastXML.fileName, withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        _ = RocketCast.XMLParser(url: stringPath)
        
        let podcast = DatabaseController.getPodcast(byTitle: noEpisodesPodcastXML.title)
        XCTAssertEqual(noEpisodesPodcastXML.title,  podcast.title)
        XCTAssertEqual(noEpisodesPodcastXML.description, podcast.summary)
        XCTAssertEqual(noEpisodesPodcastXML.imageURL, podcast.imageURL)
        XCTAssertEqual(0, podcast.episodes!.count)
        
        
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // Delete Everything
        super.tearDown()
        DatabaseController.deleteAllManagedObjects()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
   func compareValues(_ episode: Episode,expectedEpisode:[String:String]) {
        XCTAssertEqual(expectedEpisode["title"], episode.title)
        XCTAssertEqual(expectedEpisode["description"], episode.summary)
        XCTAssertEqual(expectedEpisode["author"], episode.author)
        XCTAssertEqual(expectedEpisode["date"], episode.date?.description)
        XCTAssertEqual(expectedEpisode["image"], episode.imageURL)
        XCTAssertEqual(expectedEpisode["audio"], episode.audioURL)
    }
    
}
