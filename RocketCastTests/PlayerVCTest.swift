//
//  PlayerVCTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-08.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//
import UIKit
import XCTest
@testable import RocketCast

class PlayerVCTest: XCTestCase {
    
    var playerVC:PlayerController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let podcast = mockPodcast()
        let firstEpisode = (podcast.episodes?.allObjects as! [Episode])[0]
        playerVC =  storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier.playerVC) as! PlayerController
        
        var done = false
        var path = ""
        ModelBridge.sharedInstance.downloadAudio(firstEpisode.audioURL!, result: { (downloadedPodcast) in
            done = true
            
            XCTAssertNotNil(downloadedPodcast)
            
            path = NSHomeDirectory() + downloadedPodcast!
            print("Done")
        })
        
        waitUntil(6) {done}
        firstEpisode.doucmentaudioURL = path

        AudioEpisodeTracker.isPlaying = true
        AudioEpisodeTracker.episodeIndex = 0
        AudioEpisodeTracker.currentEpisodesInTrack = [firstEpisode]
        let fileMgr = FileManager.default
        let file = fileMgr.contents(atPath: path)
        AudioEpisodeTracker.loadAudioDataToAudioPlayer(file!)
        let _ = playerVC?.view
       

        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovingSlider() {
        AudioEpisodeTracker.audioPlayer.play()
        let initalSliderPosition = AudioEpisodeTracker.audioPlayer.currentTime
        sleep(4)
        var laterSliderPosition = AudioEpisodeTracker.audioPlayer.currentTime
        let greater = (Double(laterSliderPosition) > Double(initalSliderPosition))
        let speed1Value = Double(laterSliderPosition) - Double(initalSliderPosition)
        XCTAssertTrue(greater)
        sleep(4)
        
        
        playerVC?.mainView?.viewDelegate?.changeSpeed()
        
        let speed2Value = AudioEpisodeTracker.audioPlayer.currentTime - laterSliderPosition
        
        laterSliderPosition = AudioEpisodeTracker.audioPlayer.currentTime
        XCTAssertTrue(speed2Value > speed1Value)
        
        playerVC?.mainView?.viewDelegate?.changeSpeed()
        sleep(4)
        let speed3Value = AudioEpisodeTracker.audioPlayer.currentTime - laterSliderPosition
        XCTAssertTrue(speed3Value > speed2Value)
        AudioEpisodeTracker.audioPlayer.stop()
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
        episode.title = "Thursday Afternoon Monday Morning Podcast 9-8-16"
        episode.imageURL = "http://www.josepvinaixa.com/blog/wp-content/uploads/2015/10/ADELE-Hello-2015-1400x1400.jp"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        let date = dateFormatter.date(from: "Thu, 08 Sep 2016 21:28:15 +0000")
        
        episode.date = date
        
        let episodes = podcast.episodes!.mutableCopy() as! NSMutableSet
        episodes.add(episode)
        podcast.episodes = episodes.copy() as? NSSet
        
        
        return podcast
    }
    
    fileprivate func waitUntil(_ timeout: TimeInterval, predicate:((Void) -> Bool)) {
        let timeoutTime = Date(timeIntervalSinceNow: timeout).timeIntervalSinceReferenceDate
        
        while (!predicate() && Date.timeIntervalSinceReferenceDate < timeoutTime) {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 5))
        }
    }


    
}
