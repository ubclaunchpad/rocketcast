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
    var trackId = 0
    
    enum speedRates {
        static let single:Float = 1
        static let double:Float = 2
        static let triple:Float = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PlayerView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.updateUI(episode: currentEpisodeList[self.trackId])
        self.mainView?.viewDelegate = self
        self.loadUpAudioEpisode()
    }
    
    func loadUpAudioEpisode() {
        if let url = currentEpisodeList[trackId].doucmentaudioURL {
            self.setUpPlayer(webUrl:url)
        } else {
            print("LOADING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            var done = false
            ModelBridge.sharedInstance.downloadAudio((currentEpisodeList[self.trackId].audioURL)!, result: { (downloadedPodcast) in
                let episode = DatabaseController.getEpisode((currentEpisodeList[self.trackId].title)!)
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
    
    func setUpPlayer(webUrl:String) {
        
        let fileMgr = FileManager.default
        let path = NSHomeDirectory() + webUrl
        let file = fileMgr.contents(atPath: path)
        do {
            audioPlayer = try AVAudioPlayer(data: file!)
            self.mainView?.slider.minimumValue = Float(0.0)
            self.mainView?.slider.maximumValue = Float(audioPlayer.duration)
            audioPlayer.prepareToPlay()
            audioPlayer.enableRate = true
            
            audioPlayer.play()
            
            
            let audioSession = AVAudioSession.sharedInstance()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
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

    func segueBackToEpisodes() {
        let shouldReloadNewEpisodeTrack = false
        performSegue(withIdentifier: Segues.segueToBackEpisodes, sender: shouldReloadNewEpisodeTrack)
    }
    
    func updateProgressView(){
        print(audioPlayer.duration)
        print(audioPlayer.currentTime)
        self.mainView?.slider.value = Float(audioPlayer.currentTime)
        if ((self.mainView?.slider.value)! < (self.mainView?.slider.maximumValue)!  &&
            (self.mainView?.slider.value)! > ((self.mainView?.slider.maximumValue)! - 5) ) {
            playNextEpisode()
        }
    }
    
    func playNextEpisode() {
        guard trackId >= 0 && trackId+1 < currentEpisodeList.count  else {
            return
        }
        
        trackId += 1
        
        self.mainView?.titleLabel.text = currentEpisodeList[trackId].title
        print(currentEpisodeList[trackId].title)
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        self.mainView?.slider.setValue(0.0, animated: false)
        self.mainView?.slider.maximumValue = Float(audioPlayer.duration)
        
        self.loadUpAudioEpisode()
    }
    
    func playLastEpisode() {
        guard trackId-1 >= 0 && (trackId) < currentEpisodeList.count else  {
            return
        }
        
        trackId -= 1
        
        self.mainView?.titleLabel.text = currentEpisodeList[trackId].title
        print(currentEpisodeList[trackId].title)
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        self.mainView?.slider.setValue(0.0, animated: false)
        self.mainView?.slider.maximumValue = Float(audioPlayer.duration)
        self.loadUpAudioEpisode()
        
    }
}


