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
import MediaPlayer

class PlayerController: UIViewController {
    
    var mainView: PlayerView?
    
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupView()
        setupMPRemote()
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
            self.downloadAudioEpisode()
        } else {
            self.mainView?.slider.minimumValue = 0
            self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
            self.mainView?.slider.setValue(Float(AudioEpisodeTracker.audioPlayer.currentTime), animated: false)
            AudioEpisodeTracker.currentTimerForSlider = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        }
    }
    
    func setupMPRemote() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(PlayerController.playPodcast))
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(PlayerController.pausePodcast))
        
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [30]
        commandCenter.skipBackwardCommand.addTarget(self, action: #selector(PlayerController.goBack))
        
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipForwardCommand.addTarget(self, action: #selector(PlayerController.goForward))
        
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: AudioEpisodeTracker.episodeTitle,
            MPMediaItemPropertyAlbumTitle: AudioEpisodeTracker.podcastTitle,
            MPMediaItemPropertyArtist: AudioEpisodeTracker.getCurrentEpisode().author ?? ""
//            MPMediaItemPropertyPlaybackDuration: AudioEpisodeTracker.audioPlayer.duration.,
//            MPNowPlayingInfoPropertyElapsedPlaybackTime: audioPlayer.progress
//            MPMediaItemArtwork: mainView?.coverPhotoView.subviews.last
        ]
    }
    
    func downloadAudioEpisode() {
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
            
            guard AudioEpisodeTracker.episodeIndex != -1 else {
                return
            }
            
            guard let episodeTitle = AudioEpisodeTracker.getCurrentEpisode().title else {
                return
            }
            
            let episode = DatabaseUtil.getEpisode(episodeTitle)
            episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
            DatabaseUtil.saveContext()
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
    
    func deleteEpisode(){
        let episode = AudioEpisodeTracker.getCurrentEpisode()
        AudioEpisodeTracker.resetAudioTracker();
        DatabaseUtil.deleteEpisodeAudio(episodeTitle: episode.title!)
        
    }
    // TODO use Guard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EpisodeController {
            if let podcast = sender as? Podcast {
                let episodes = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
                destination.episodesInPodcast = episodes
                destination.selectedPodcast = podcast
            }
        }
    }
}

// reference to https://github.com/maranathApp/Music-Player-App-Final-Project/blob/master/PlayerViewController.swift
extension PlayerController: PlayerViewDelegate {
    func openDeleteModal() {
        self.alertController = UIAlertController(title: "Delete Episode", message: "Are you sure you want to delete this Episode?", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            Log.info("Deleted Episode")
            self.closeDeleteModal()
            self.navigationController?.popViewController(animated: true)
            self.deleteEpisode()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            Log.info("Did not Delete Episode")
            self.closeDeleteModal()
        }
        self.alertController?.addAction(DestructiveAction)
        self.alertController?.addAction(cancelAction)
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func closeDeleteModal() {
        if (self.alertController != nil) {
            self.alertController?.dismiss(animated: true)
        }
    }
    
    func playPodcast() {
        if !AudioEpisodeTracker.audioPlayer.isPlaying {
          print(AudioEpisodeTracker.audioPlayer.currentTime)
            AudioEpisodeTracker.audioPlayer.prepareToPlay()
            AudioEpisodeTracker.currentTimerForSlider = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
            AudioEpisodeTracker.audioPlayer.play()
        }
    }
    
    func pausePodcast() {
        AudioEpisodeTracker.audioPlayer.pause()
        AudioEpisodeTracker.currentTimerForSlider.invalidate()
    }
    
    func stopPodcast() {
        AudioEpisodeTracker.audioPlayer.stop()
        AudioEpisodeTracker.currentTimerForSlider.invalidate()
    }
    
    func goForward() {
        var time: TimeInterval = AudioEpisodeTracker.audioPlayer.currentTime
        time += 30.0 // Go forward by 30 seconds
        if time > AudioEpisodeTracker.audioPlayer.duration{
            AudioEpisodeTracker.audioPlayer.currentTime = AudioEpisodeTracker.audioPlayer.duration - 1
            AudioEpisodeTracker.audioPlayer.play()
        } else{
            AudioEpisodeTracker.audioPlayer.currentTime = time
            AudioEpisodeTracker.audioPlayer.play()
        }
    }
    
    func goBack() {
        var time: TimeInterval = AudioEpisodeTracker.audioPlayer.currentTime
        time -= 30.0 // Go backward by 30 seconds
        if time < 0.0{
            AudioEpisodeTracker.audioPlayer.currentTime = 0.0
            AudioEpisodeTracker.audioPlayer.play()
        } else{
            AudioEpisodeTracker.audioPlayer.currentTime = time
            AudioEpisodeTracker.audioPlayer.play()
        }
    }
    
    func setUpPlayer(webUrl:String) {
        
        let fileMgr = FileManager.default
        let path = NSHomeDirectory() + webUrl
        let file = fileMgr.contents(atPath: path)
        
        AudioEpisodeTracker.loadAudioDataToAudioPlayer(file!)
        self.mainView?.slider.setValue(0.0, animated: false)
        self.mainView?.slider.maximumValue = Float(AudioEpisodeTracker.audioPlayer.duration)
        AudioEpisodeTracker.audioPlayer.play()
        mainView?.isPlaying = true
        
        let audioSession = AVAudioSession.sharedInstance()
        AudioEpisodeTracker.currentTimerForSlider = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
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

    
    func updateProgressView() {
        guard mainView?.sliderIsMoving == false else {
            return
        }

        guard !AudioEpisodeTracker.isTheAudioEmpty else {
            return
        }
        
        self.mainView?.slider.setValue(Float(AudioEpisodeTracker.audioPlayer.currentTime), animated: true)
        
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
        AudioEpisodeTracker.resetAudioData()
        self.mainView?.titleLabel.text = AudioEpisodeTracker.getCurrentEpisode().title
        
        self.downloadAudioEpisode()
    }
 }
