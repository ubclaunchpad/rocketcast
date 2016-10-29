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
        print(currentEpisodeList[trackId].title)
        if let url = currentEpisodeList[trackId].doucmentaudioURL {
            self.setUpPlayer(webUrl:url)
        } else {
            print("LOADING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            ModelBridge.sharedInstance.downloadAudio((currentEpisodeList[trackId].audioURL)!, result: { (downloadedPodcast) in
                let episode = DatabaseController.getEpisode((currentEpisodeList[self.trackId].title)!)
                episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
                DatabaseController.saveContext()
                Log.debug("IsPlaying: \(isPlaying)")
                 print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    self.setUpPlayer(webUrl: downloadedPodcast!)
           
            })
        }
    }
    
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PlayerView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
        self.mainView?.updateUI(episode: currentEpisodeList[self.trackId])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        // Run the tests in DownloadTests.swift in order for this play
        //let path = NSHomeDirectory() + "/Documents/https:ia902508usarchiveorg5itemstestmp3testfilempthreetestmp3"
        
        let fileMgr = FileManager.default
        let path = NSHomeDirectory() + webUrl
        let file = fileMgr.contents(atPath: path)
        do {
            audioPlayer = try AVAudioPlayer(data: file!)
            
            audioPlayer.prepareToPlay()
            audioPlayer.enableRate = true
            audioPlayer.play()
            self.mainView?.slider.maximumValue = Float(audioPlayer.duration)
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
    
    func getEpisodeTitle() -> String {
        guard currentEpisodeList[trackId] != nil else {
            Log.error("episode should not have been nil")
            return ""
        }
        
        return (currentEpisodeList[trackId].title)! as String
    }
    
    func getEpisodeDesc() -> String {
        guard currentEpisodeList[trackId] != nil else {
            Log.error("episode should not have been nil")
            return ""
        }
        
        return (currentEpisodeList[trackId].description) as String
    }
    
    func getEpisodeImage(_ result: (_ image: UIImage) -> ()) {
        guard currentEpisodeList[trackId] != nil else {
            Log.error("episode should not have been nil")
            return
        }
        
        // download image from episodes imageURL
        // return that image in result
    }
    
    func segueBackToEpisodes() {
        performSegue(withIdentifier: Segues.segueToBackEpisodes, sender: self)
    }
    
    func updateProgressView(){
        self.mainView?.slider.value = Float(audioPlayer.currentTime)
        print(self.mainView?.slider.value)
        print(self.mainView?.slider.maximumValue)
        if ((self.mainView?.slider.value)! < (self.mainView?.slider.maximumValue)!  &&
           (self.mainView?.slider.value)! > ((self.mainView?.slider.maximumValue)! - 5) ) {
            playNextEpisode()
        }
    }
    
    func playNextEpisode() {
        if trackId >= 0 && trackId+1 <= currentEpisodeList.count {
            
            trackId += 1
            
            self.mainView?.titleLabel.text = currentEpisodeList[trackId].title
            print(currentEpisodeList[trackId].title)
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            self.mainView?.slider.setValue(0.0, animated: false)
            self.mainView?.slider.maximumValue = Float(audioPlayer.duration)
            
            if let url = currentEpisodeList[trackId].doucmentaudioURL {
                self.setUpPlayer(webUrl:url)
            } else {
                print("LOADING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                ModelBridge.sharedInstance.downloadAudio((currentEpisodeList[trackId].audioURL)!, result: { (downloadedPodcast) in
                    let episode = DatabaseController.getEpisode((currentEpisodeList[self.trackId].title)!)
                    episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
                    DatabaseController.saveContext()
                    Log.debug("IsPlaying: \(isPlaying)")
                    print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    self.setUpPlayer(webUrl: downloadedPodcast!)
                    
                })
            }
        }
    }
    
    func playLastEpisode() {
        if trackId-1 >= 0 && (trackId) < currentEpisodeList.count {
            
            trackId -= 1
            
            self.mainView?.titleLabel.text = currentEpisodeList[trackId].title
             print(currentEpisodeList[trackId].title)
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            self.mainView?.slider.setValue(0.0, animated: false)
            self.mainView?.slider.maximumValue = Float(audioPlayer.duration)
            
            if let url = currentEpisodeList[trackId].doucmentaudioURL {
                self.setUpPlayer(webUrl:url)
            } else {
                print("LOADING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                ModelBridge.sharedInstance.downloadAudio((currentEpisodeList[trackId].audioURL)!, result: { (downloadedPodcast) in
                    let episode = DatabaseController.getEpisode((currentEpisodeList[self.trackId].title)!)
                    episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
                    DatabaseController.saveContext()
                    Log.debug("IsPlaying: \(isPlaying)")
                    print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    self.setUpPlayer(webUrl: downloadedPodcast!)
                    
                })
            }
        }

    }

    
}
