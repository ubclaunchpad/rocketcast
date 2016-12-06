//
//  PodcastViewControllerTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-04.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import XCTest
@testable import RocketCast
import CoreData
class PodcastViewControllerTest: XCTestCase {
    
    
    var urlVC: AddUrlController!
    override func setUp() {
        super.setUp()
        urlVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.urlVC) as! AddUrlController
        urlVC.viewDidLoad()
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddPodcastViaURL() {
        sleep(3)
        let podcastVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.podcastVC) as! PodcastController
        
        podcastVC.viewDidLoad()
        
        let podcastCollectionView = podcastVC.mainView?.podcastView
        XCTAssertEqual(2, podcastCollectionView?.numberOfSections)
        XCTAssertEqual(1, podcastCollectionView?.numberOfItems(inSection: 1))
        
        // Section 1 is the title of the collection view
        let titleCollectionView = podcastVC.mainView?.collectionView(podcastCollectionView!, cellForItemAt:  IndexPath(item: 0, section: 0)) as! PodcastsTitleCollectionViewCell
        XCTAssertEqual("Podcasts", titleCollectionView.titleLabel.text)
        
        // Section 2 shows you the podcasts
         sleep(8)
        if   let firstPodcastCollectionView =  podcastVC.mainView?.collectionView(podcastCollectionView!, cellForItemAt: IndexPath(item: 0, section: 1)) as? PodcastViewCollectionViewCell {
            XCTAssertEqual(SamplePodcast.podcastTitle, firstPodcastCollectionView.podcastTitle.text)
            XCTAssertEqual(SamplePodcast.author, firstPodcastCollectionView.podcastAuthor.text)

        }
    }
    
    func testAddTheSamePodcast() {
        XCTAssertEqual(1, DatabaseUtil.getAllPodcasts().count)
        
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
        XCTAssertEqual(1, DatabaseUtil.getAllPodcasts().count)
        
    }
    
    func testReloadPodcast () {
        
        let podcastVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.podcastVC) as! PodcastController
        
        podcastVC.viewDidLoad()
        let episodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.episodeVC) as! EpisodeController
        
        for _ in 0...1{
            let podcast = DatabaseUtil.getPodcast(byTitle: SamplePodcast.podcastTitle)
            episodeVC.selectedPodcast = podcast
            episodeVC.episodesInPodcast = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
            
            episodeVC.viewDidLoad()
            episodeVC.viewDidAppear(true)
            
            let episodeTables = episodeVC.mainView?.EpisodeTable
            
            XCTAssertEqual(2, episodeTables?.numberOfSections)
            XCTAssertEqual(2, episodeTables?.numberOfRows(inSection: 1))
            
            let headerEpisodeTable = episodeVC.mainView?.tableView(episodeTables!, cellForRowAt: IndexPath(item: 0, section: 0)) as! EpisodeHeaderTableViewCell
            
            XCTAssertEqual(SamplePodcast.podcastTitle, headerEpisodeTable.podcastTitle.text)
            XCTAssertEqual(SamplePodcast.author, headerEpisodeTable.podcastAuthor.text)
            
            
            for i in 0...1 {
                let cellEpisodeTable = episodeVC.mainView?.tableView(episodeTables!, cellForRowAt: IndexPath(item: i, section: 1)) as! EpisodeViewTableViewCell
                
                XCTAssertEqual(tapToDownload, cellEpisodeTable.downloadStatus.text)
                XCTAssertEqual(SamplePodcast.listOfEpisodes[i], cellEpisodeTable.episodeHeader.text)
            }
            
            episodeVC.mainView?.tableView(episodeTables!, didSelectRowAt: IndexPath(item: 0, section: 1))
            episodeTables?.reloadData()
            var cellEpisodeTable = episodeVC.mainView?.tableView(episodeTables!, cellForRowAt: IndexPath(item: 0, section: 1)) as! EpisodeViewTableViewCell
            XCTAssertEqual(downloading, cellEpisodeTable.downloadStatus.text)
            var firstEpisode = DatabaseUtil.getEpisode(SamplePodcast.firstEpisode)
            while (firstEpisode?.doucmentaudioURL == nil) {
                firstEpisode = DatabaseUtil.getEpisode(SamplePodcast.firstEpisode)
            }
            cellEpisodeTable = episodeVC.mainView?.tableView(episodeTables!, cellForRowAt: IndexPath(item: 0, section: 1)) as! EpisodeViewTableViewCell
            episodeTables?.reloadData()
            XCTAssertEqual(tapToDownload, cellEpisodeTable.downloadStatus.text )
            
            
            podcastVC.updateAllPodcasts()
        }

    }
    
}
