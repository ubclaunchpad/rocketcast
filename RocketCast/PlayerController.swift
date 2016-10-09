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
    
    let speedRates: [Float] = [1,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //TODO: call this from performSegue function in EpisodeController not here!
        let seguedEpisode = Episode()
        setUpPodcast(seguedEpisode);
        setUpPlayer()
    }
    
    private func setupView() {
        let viewSize = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        mainView = PlayerView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpPodcast(episodeToPlay: Episode) {
        episode = episodeToPlay
    }
}

// reference to https://github.com/maranathApp/Music-Player-App-Final-Project/blob/master/PlayerViewController.swift
extension PlayerController: PlayerViewDelegate {
    func playPodcast() {
        if !audioPlayer.playing {
            audioPlayer.play()
        }
    }
    
    func pausePodcast() {
        audioPlayer.pause()
    }
    
    func stopPodcast() {
        audioPlayer.stop()
    }
    
    func setUpPlayer() {
        let fileMgr = NSFileManager.defaultManager()
        
        // Run the tests in DownloadTests.swift in order for this play
        let path = NSHomeDirectory().stringByAppendingString("/Documents/wwwscientificamericancompodcastpodcastmp3?fileId=14824345-7D79-454F-9A8F30B98EE219F3")

        let file = fileMgr.contentsAtPath(path)
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
    
    func changeSpeed(rateTag: Int) {
        audioPlayer.rate = speedRates[rateTag]
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
    
    func getEpisodeImage(result: (image: UIImage) -> ()) {
        guard episode != nil else {
            Log.error("episode should not have been nil")
            return
        }
        
        // download image from episodes imageURL
        // return that image in result
    }
    
}