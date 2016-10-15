//
//  PlayerController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerController: UIViewController {
    
    var mainView: PlayerView?
    var audioPlayer: AVAudioPlayer!
    var episode: Episode?
    
    enum speedRates {
        static let single:Float = 1
        static let double:Float = 2
        static let triple:Float = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //TODO: call this from performSegue function in EpisodeController not here!
        let seguedEpisode = Episode()
        setUpPodcast(seguedEpisode);
        setUpPlayer()
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PlayerView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpPodcast(_ episodeToPlay: Episode) {
        episode = episodeToPlay
    }
}

// reference to https://github.com/maranathApp/Music-Player-App-Final-Project/blob/master/PlayerViewController.swift
extension PlayerController: PlayerViewDelegate {
    func playPodcast() {
        if !audioPlayer.isPlaying {
            audioPlayer.play()
        }
    }
    
    func pausePodcast() {
        audioPlayer.pause()
    }
    
    func stopPodcast() {
        audioPlayer.stop()
    }
    
    func goForward() {
        audioPlayer.play(atTime: audioPlayer.currentTime+30)
    }
    
    func goBack() {
        audioPlayer.play(atTime: audioPlayer.currentTime-30)
    }
    
    func setUpPlayer() {
        let fileMgr = FileManager.default
        
        // Run the tests in DownloadTests.swift in order for this play
        let path = NSHomeDirectory() + "/Documents/https:ia902508usarchiveorg5itemstestmp3testfilempthreetestmp3"

        let file = fileMgr.contents(atPath: path)
        // Uncomment when episode.audioURL is accessible
//         let path = NSBundle.mainBundle().pathForResource(episode?.audioURL, ofType: "mp3")
//         if let path = path {
//         let mp3URL = NSURL(fileURLWithPath: path)
        
            do {
                audioPlayer = try AVAudioPlayer(data: file!)
                
                audioPlayer.prepareToPlay()
                audioPlayer.enableRate = true
         
            } catch let error as NSError {
                Log.error(error.localizedDescription)
            }
//         }
    }
    
    func changeSpeed(_ rateTag: Int) {
        switch rateTag {
        case Int(speedRates.single):
            audioPlayer.rate = speedRates.single
            break
        case Int(speedRates.double):
            audioPlayer.rate = speedRates.double
            break
        case Int(speedRates.triple):
            audioPlayer.rate = speedRates.triple
            break
        default:
            break
        }
    }
    
    func getEpisodeTitle() -> String {
        guard episode != nil else {
            Log.error("episode should not have been nil")
            return ""
        }
        
        return (episode?.title)! as String
    }
    
    func getEpisodeDesc() -> String {
        guard episode != nil else {
            Log.error("episode should not have been nil")
            return ""
        }
        
        return (episode?.description)! as String
    }
    
    func getEpisodeImage(_ result: (_ image: UIImage) -> ()) {
        guard episode != nil else {
            Log.error("episode should not have been nil")
            return
        }
        
        // download image from episodes imageURL
        // return that image in result
    }
    
}
