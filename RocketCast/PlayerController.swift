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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        // set up audioPlayer with proper podcast episode
        
        /*
         let path = NSBundle.mainBundle().pathForResource("\(trackId)", ofType: "mp3")
         
         if let path = path {
            let mp3URL = NSURL(fileURLWithPath: path)
         
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: mp3URL)
                audioPlayer.play()
         
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlayerViewController.updateProgressView), userInfo: nil, repeats: true)
                progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
         
            } catch let error as NSError {
                Log.error(error.localizedDescription)
            }
         }
         */
    }
    
}