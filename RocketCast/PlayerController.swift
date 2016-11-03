//
//  PlayerController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
class PlayerController: UIViewController {
    
    var mainView: PlayerView?
    
    enum speedRates {
        static let single:Float = 1
        static let double:Float = 2
        static let triple:Float = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupView()
    }
    
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PlayerView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.updateUI(episode: AudioEpisodeTracker.getCurrentEpisode())
        self.mainView?.viewDelegate = self
        if (!AudioEpisodeTracker.isPlaying) {
            self.loadUpAudioEpisode()
        } else {
            self.mainView?.slider.minimumValue = 0
            self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
            self.mainView?.slider.setValue(Float(AudioEpisodeTracker.audioPlayer.currentTime), animated: false)
            AudioEpisodeTracker.currentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        }
        
    }
    
    func loadUpAudioEpisode() {
        if let url =  AudioEpisodeTracker.getCurrentEpisode().doucmentaudioURL {
            self.setUpPlayer(webUrl:url)
        } else {
            print("LOADING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            var done = false
            ModelBridge.sharedInstance.downloadAudio((AudioEpisodeTracker.getCurrentEpisode().audioURL)!, result: { (downloadedPodcast) in
                let episode = DatabaseController.getEpisode((AudioEpisodeTracker.getCurrentEpisode().title)!)
                episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
                DatabaseController.saveContext()
                print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                done = true
            })
            while(!done){}
            self.loadUpAudioEpisode()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Segues.segueToBackEpisodes  else {
            return
        }
        
        if let shouldReloadNewEpisodeTrackList = sender as? Bool {
            if let destination = segue.destination as? EpisodeController {
                destination.shouldReloadNewEpisodeTrack = shouldReloadNewEpisodeTrackList

            }
        }
    }
}

// reference to https://github.com/maranathApp/Music-Player-App-Final-Project/blob/master/PlayerViewController.swift
extension PlayerController: PlayerViewDelegate {
    func playPodcast() {
        if !AudioEpisodeTracker.audioPlayer.isPlaying {
          print(AudioEpisodeTracker.audioPlayer.currentTime)
            AudioEpisodeTracker.audioPlayer.prepareToPlay()
            AudioEpisodeTracker.currentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            AudioEpisodeTracker.audioPlayer.play()

        }
    }
    
    func pausePodcast() {
        AudioEpisodeTracker.audioPlayer.pause()
        AudioEpisodeTracker.currentTimer.invalidate()
    }
    
    func stopPodcast() {
        AudioEpisodeTracker.audioPlayer.stop()
        AudioEpisodeTracker.currentTimer.invalidate()
    }
    
    func goForward() {
        AudioEpisodeTracker.audioPlayer.play(atTime: AudioEpisodeTracker.audioPlayer.currentTime+30)
    }
    
    func goBack() {
        AudioEpisodeTracker.audioPlayer.play(atTime: AudioEpisodeTracker.audioPlayer.currentTime-30)
    }
    
    func setUpPlayer(webUrl:String) {
        
        let fileMgr = FileManager.default
        let path = NSHomeDirectory() + webUrl
        let file = fileMgr.contents(atPath: path)
        do {
            AudioEpisodeTracker.audioPlayer = try AVAudioPlayer(data: file!)
            self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
            
            AudioEpisodeTracker.audioPlayer.prepareToPlay()
            AudioEpisodeTracker.audioPlayer.enableRate = true
            AudioEpisodeTracker.audioPlayer.play()
            AudioEpisodeTracker.isPlaying = true
            
            let audioSession = AVAudioSession.sharedInstance()
           AudioEpisodeTracker.currentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                
            }
        
        } catch let error as NSError {
            Log.error(error.localizedDescription)
        }
        
    }
    
    func changeSpeed(_ rateTag: Int) {
        switch rateTag {
        case Int(speedRates.single):
            AudioEpisodeTracker.audioPlayer.rate = speedRates.single
            break
        case Int(speedRates.double):
            AudioEpisodeTracker.audioPlayer.rate = speedRates.double
            break
        case Int(speedRates.triple):
            AudioEpisodeTracker.audioPlayer.rate = speedRates.triple
            break
        default:
            break
        }
    }

    func segueBackToEpisodes() {
        let shouldReloadNewEpisodeTrack = false
        performSegue(withIdentifier: Segues.segueToBackEpisodes, sender: shouldReloadNewEpisodeTrack)
    }
    
    func updateProgressView(){
        Log.info("\(self.mainView?.slider.value)")
        Log.info("\(AudioEpisodeTracker.audioPlayer.currentTime)")
        self.mainView?.slider.setValue(Float(AudioEpisodeTracker.audioPlayer.currentTime), animated: false)
        if ((self.mainView?.slider.value)! < (self.mainView?.slider.maximumValue)!  &&
            (self.mainView?.slider.value)! > ((self.mainView?.slider.maximumValue)! - 3) ) {
            playNextEpisode()
        }
    }
    
    func playNextEpisode() {
        guard AudioEpisodeTracker.episodeIndex >= 0 &&
            AudioEpisodeTracker.episodeIndex+1 < AudioEpisodeTracker.currentEpisodesInTrack.count  else {
            return
        }
        
        AudioEpisodeTracker.episodeIndex += 1
        
        self.mainView?.titleLabel.text = AudioEpisodeTracker.getCurrentEpisode().title
        
        AudioEpisodeTracker.audioPlayer.stop()
        AudioEpisodeTracker.audioPlayer.currentTime = 0
        self.mainView?.slider.setValue(0.0, animated: false)
        self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
        
        self.loadUpAudioEpisode()
    }
    
    func playLastEpisode() {
        guard AudioEpisodeTracker.episodeIndex-1 >= 0
            && (AudioEpisodeTracker.episodeIndex) < AudioEpisodeTracker.currentEpisodesInTrack.count else  {
            return
        }
        
        AudioEpisodeTracker.episodeIndex -= 1
        
        self.mainView?.titleLabel.text = AudioEpisodeTracker.getCurrentEpisode().title

        AudioEpisodeTracker.audioPlayer.stop()
        AudioEpisodeTracker.audioPlayer.currentTime = 0
        self.mainView?.slider.setValue(0.0, animated: false)
        self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
        self.loadUpAudioEpisode()
        
    }
}


