//
//  PlayerVC.swift
//  RocketCast
//
//  Created by James Park on 2016-12-07.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import XCTest
@testable import RocketCast
class PlayerVC: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovingSlider() {
        
        _ = RocketCast.CoreDataXMLParser(url: "https://s3-us-west-2.amazonaws.com/podcastassets/Episodes/testPodcastMadeup.xml")
        
        
        let podcastVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.podcastVC) as! PodcastController
        _ = podcastVC.view
    
        let podcast = DatabaseUtil.getPodcast(byTitle: SamplePodcast.podcastTitle)
        podcastVC.setSelectedPodcastAndSegue(selectedPodcast: podcast)
        let episodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.episodeVC) as! EpisodeController
        
        episodeVC.selectedPodcast = podcast
        episodeVC.episodesInPodcast = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
        
       _ = episodeVC.view
        episodeVC.viewDidLoad()
        episodeVC.viewDidAppear(true)
        
        let episodeTables = episodeVC.mainView?.EpisodeTable
        
        XCTAssertEqual(2, episodeTables?.numberOfSections)
        XCTAssertEqual(2, episodeTables?.numberOfRows(inSection: 1))
        
        // tap the episode
        episodeVC.mainView?.tableView(episodeTables!, didSelectRowAt: IndexPath(item: 0, section: 1))
        episodeTables?.reloadData()
        
        var firstEpisode = DatabaseUtil.getEpisode(SamplePodcast.firstEpisode)
        while (firstEpisode?.doucmentaudioURL == nil) {
            firstEpisode = DatabaseUtil.getEpisode(SamplePodcast.firstEpisode)
        }
        
        episodeVC.mainView?.tableView(episodeTables!, didSelectRowAt: IndexPath(item: 0, section: 1))
        sleep(8)
        let playerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.playerVC) as! PlayerController
        AudioEpisodeTracker.episodeIndex = 1
        AudioEpisodeTracker.currentEpisodesInTrack = Array(podcast.episodes!) as! [Episode]
        playerVC.viewDidLoad()
        
        let fileMgr = FileManager.default
        let path = NSHomeDirectory() + (firstEpisode?.doucmentaudioURL)!
        let file = fileMgr.contents(atPath: path)
        AudioEpisodeTracker.loadAudioDataToAudioPlayer(file!)
        AudioEpisodeTracker.audioPlayer.play()
        let initalSliderPosition = AudioEpisodeTracker.audioPlayer.currentTime
        sleep(4)
        var laterSliderPosition = AudioEpisodeTracker.audioPlayer.currentTime
        let greater = (Double(laterSliderPosition) > Double(initalSliderPosition))
        let speed1Value = Double(laterSliderPosition) - Double(initalSliderPosition)
        XCTAssertTrue(greater)
        sleep(4)
        
        
        playerVC.mainView?.viewDelegate?.changeSpeed()
        
        let speed2Value = AudioEpisodeTracker.audioPlayer.currentTime - laterSliderPosition
        
        laterSliderPosition = AudioEpisodeTracker.audioPlayer.currentTime
        XCTAssertTrue(speed2Value > speed1Value)
        
        playerVC.mainView?.viewDelegate?.changeSpeed()
        sleep(4)
        let speed3Value = AudioEpisodeTracker.audioPlayer.currentTime - laterSliderPosition
        XCTAssertTrue(speed3Value > speed2Value)
        
        DatabaseUtil.deleteAllManagedObjects()
    }
    
}
