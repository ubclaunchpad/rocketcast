//
//  EpisodeVCTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import XCTest
@testable import RocketCast
import CoreData
class EpisodeVCTest: XCTestCase {
    
    var episodeVC:EpisodeController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let podcast = mockPodcast()
        
        episodeVC = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier.episodeVC) as! EpisodeController
                
        episodeVC?.selectedPodcast = podcast
        episodeVC?.episodesInPodcast = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
        
        
        let _ = episodeVC?.view
        episodeVC?.viewDidAppear(true)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEpisodeView() {
        
        let episodeTables = episodeVC?.mainView?.EpisodeTable
        
        
        XCTAssertEqual(2, episodeTables?.numberOfSections)
        XCTAssertEqual(1, episodeTables?.numberOfRows(inSection: 1))
        
        let headerEpisodeTable = episodeVC?.mainView?.tableView(episodeTables!, cellForRowAt: IndexPath(item: 0, section: 0)) as! EpisodeHeaderTableViewCell
        
        XCTAssertEqual(SamplePodcast.podcastTitle, headerEpisodeTable.podcastTitle.text)
        XCTAssertEqual(SamplePodcast.author, headerEpisodeTable.podcastAuthor.text)
        

        let cellEpisodeTablePre = episodeVC?.mainView?.tableView(episodeTables!, cellForRowAt: IndexPath(item: 0, section: 1)) as! EpisodeViewTableViewCell
            
        XCTAssertEqual(tapToDownload, cellEpisodeTablePre.downloadStatus.text)
        XCTAssertEqual(SamplePodcast.listOfEpisodes[0], cellEpisodeTablePre.episodeHeader.text)
        
        
        episodeVC?.mainView?.tableView(episodeTables!, didSelectRowAt: IndexPath(item: 0, section: 1))
        episodeTables?.reloadData()
        
        sleep(10)
        
        episodeVC?.mainView?.EpisodeTable.reloadData()
    }
    
    
    func mockPodcast() -> Podcast {
        
        let podcast = Podcast(context: DatabaseUtil.getContext())
        podcast.rssFeedURL = "https://s3-us-west-2.amazonaws.com/podcastassets/Episodes/testPodcastMadeup.xml"
        
        podcast.addedDate = Date()
        podcast.title = SamplePodcast.podcastTitle
        podcast.summary = ""
        podcast.imageURL = "http://www.josepvinaixa.com/blog/wp-content/uploads/2015/10/ADELE-Hello-2015-1400x1400.jpg"
        podcast.author = "Bill Burr"
        
        let  episode = Episode(context: DatabaseUtil.getContext())
        episode.audioURL = "http://traffic.libsyn.com/billburr/TAMMP_9-8-16.mp3"
        episode.duration = "01:07:59"
        episode.author = "Bill Burr"
        episode.title = SamplePodcast.firstEpisode
        episode.imageURL = "http://www.josepvinaixa.com/blog/wp-content/uploads/2015/10/ADELE-Hello-2015-1400x1400.jpg"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        let date = dateFormatter.date(from: "Thu, 08 Sep 2016 21:28:15 +0000")
        
        episode.date = date
        
        let episodes = podcast.episodes!.mutableCopy() as! NSMutableSet
        episodes.add(episode)
        podcast.episodes = episodes.copy() as? NSSet

        return podcast
    }
}
