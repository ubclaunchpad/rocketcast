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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupView()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        mainView?.updateUI(episode: AudioEpisodeTracker.getCurrentEpisode())
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PlayerView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.updateUI(episode: AudioEpisodeTracker.getCurrentEpisode())
        self.mainView?.setStyling()
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
        guard  AudioEpisodeTracker.getCurrentEpisode().doucmentaudioURL == nil else  {
            self.setUpPlayer(webUrl: AudioEpisodeTracker.getCurrentEpisode().doucmentaudioURL!)
            return
        }
        
        let loadingAlertScreen = createLoadingScreen()
        ModelBridge.sharedInstance.downloadAudio((AudioEpisodeTracker.getCurrentEpisode().audioURL)!, result: { (downloadedPodcast) in
            
            guard downloadedPodcast != nil else {
                // TODO- Fix bug here
                DispatchQueue.main.async {
                    loadingAlertScreen.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            let episode = DatabaseController.getEpisode((AudioEpisodeTracker.getCurrentEpisode().title)!)
            episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
            DatabaseController.saveContext()
            DispatchQueue.main.async {
                loadingAlertScreen.dismiss(animated: true, completion: nil)
                self.createSucessScreen()
                self.setUpPlayer(webUrl:downloadedPodcast!)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createLoadingScreen () -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Loading the next episode\n\n\n", preferredStyle: .alert)
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.center = CGPoint(x: 130.5, y: 65.5)
        spinner.color = UIColor.black
        spinner.startAnimating()
        alert.view.addSubview(spinner)
        self.present(alert, animated: false, completion: nil)
        return alert
    }
    
    private func createFailedDownloaded () {
        let alert = UIAlertController(title: "Failed", message: "Failed to download episode", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    private func createSucessScreen () {
        let alert = UIAlertController(title: "Success", message: "Downloaded the episode", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
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
            AudioEpisodeTracker.currentRate = speedRates.single
            mainView?.isPlaying = true
            
            let audioSession = AVAudioSession.sharedInstance()
           AudioEpisodeTracker.currentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch let error as NSError {
                Log.error(error.localizedDescription)
            }
        
        } catch let error as NSError {
            Log.error(error.localizedDescription)
        }
    }
    
    func changeSpeed() -> String {
        switch AudioEpisodeTracker.currentRate {
        case speedRates.single:
            AudioEpisodeTracker.audioPlayer.rate = speedRates.double
            AudioEpisodeTracker.currentRate = speedRates.double
            break

        case speedRates.double:
            AudioEpisodeTracker.audioPlayer.rate = speedRates.triple
            AudioEpisodeTracker.currentRate = speedRates.triple
            break
        case speedRates.triple:
            AudioEpisodeTracker.audioPlayer.rate = speedRates.single
            AudioEpisodeTracker.currentRate = speedRates.single
            break
        default:
            break
        }
        return String(Int(AudioEpisodeTracker.currentRate))
    }

    func segueBackToEpisodes() {
        let shouldReloadNewEpisodeTrack = false
        performSegue(withIdentifier: Segues.segueToBackEpisodes, sender: shouldReloadNewEpisodeTrack)
    }
    
    func updateProgressView() {
        guard mainView?.sliderIsMoving == false else {
            return
        }
        self.mainView?.slider.setValue(Float(AudioEpisodeTracker.audioPlayer.currentTime), animated: true)
        if ((self.mainView?.slider.value)! < (self.mainView?.slider.maximumValue)!  &&
            (self.mainView?.slider.value)! > ((self.mainView?.slider.maximumValue)! - 3) ) {
            AudioEpisodeTracker.audioPlayer.stop()
            playNextEpisode()
        }
    }
    
    func playNextEpisode() {
        guard AudioEpisodeTracker.episodeIndex >= 0 &&
            AudioEpisodeTracker.episodeIndex+1 < AudioEpisodeTracker.currentEpisodesInTrack.count  else {
            return
        }
        AudioEpisodeTracker.episodeIndex += 1
        AudioEpisodeTracker.currentTimer.invalidate()
        self.mainView?.titleLabel.text = AudioEpisodeTracker.getCurrentEpisode().title
        
        AudioEpisodeTracker.audioPlayer.currentTime = 0
        self.mainView?.slider.setValue(0.0, animated: false)
        self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
        AudioEpisodeTracker.audioPlayer = AVAudioPlayer()
        self.loadUpAudioEpisode()
    }
 }
