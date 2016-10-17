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
    public var recievedEpisode: Episode?
    var coreData = CoreDataHelper()
    enum speedRates {
        static let single:Float = 1
        static let double:Float = 2
        static let triple:Float = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        print(recievedEpisode?.title)
        if let url = recievedEpisode?.doucmentaudioURL {
            if (!isPlaying) {
                self.setUpPlayer(webUrl:url)
            }
            
        } else {
            print("LOADING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            ModelBridge.sharedInstance.downloadAudio((recievedEpisode?.audioURL)!, result: { (downloadedPodcast) in
                let episode = self.coreData.getEpisode((self.recievedEpisode?.title)!)
                episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
                self.coreData.saveContext()
                Log.debug("IsPlaying: \(isPlaying)")
                 print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                if (!isPlaying) {
                    self.setUpPlayer(webUrl: downloadedPodcast!)
                }
            })
        }
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
    
    
}

// reference to https://github.com/maranathApp/Music-Player-App-Final-Project/blob/master/PlayerViewController.swift
extension PlayerController: PlayerViewDelegate {
    func playPodcast() {
        if !audioPlayer.isPlaying {
            audioPlayer.play()
            isPlaying = true
        }
    }
    
    func pausePodcast() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    func stopPodcast() {
        audioPlayer.stop()
        isPlaying = false
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
            let audioSession = AVAudioSession.sharedInstance()
            
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
        guard recievedEpisode != nil else {
            Log.error("episode should not have been nil")
            return ""
        }
        
        return (recievedEpisode?.title)! as String
    }
    
    func getEpisodeDesc() -> String {
        guard recievedEpisode != nil else {
            Log.error("episode should not have been nil")
            return ""
        }
        
        return (recievedEpisode?.description)! as String
    }
    
    func getEpisodeImage(_ result: (_ image: UIImage) -> ()) {
        guard recievedEpisode != nil else {
            Log.error("episode should not have been nil")
            return
        }
        
        // download image from episodes imageURL
        // return that image in result
    }
    
    
    func segueBackToEpisodes() {
        performSegue(withIdentifier: Segues.segueToBackEpisodes, sender: self)
        
    }
    
}
