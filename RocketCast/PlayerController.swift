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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //TODO: call this from performSegue function in EpisodeController not here!
        let seguedEpisode = Episode()
        setUpPodcast(seguedEpisode);
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
    
    func setUpPlayer() {
         let path = Bundle.main.path(forResource: episode?.audioURL, ofType: "mp3")
         
         if let path = path {
            let mp3URL = URL(fileURLWithPath: path)
         
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: mp3URL)
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
         
            } catch let error as NSError {
                Log.error(error.localizedDescription)
            }
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
