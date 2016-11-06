//
//  EpisodeController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import CoreData

class EpisodeController: UIViewController {
    
    var episodesInPodcast = [Episode]()
    var podcastTitle = ""
    var shouldReloadNewEpisodeTrack = true
    var mainView: EpisodeView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if AudioEpisodeTracker.isPlaying {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(segueToPlayer) )
        }
         setupView()
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        if (shouldReloadNewEpisodeTrack) {
            AudioEpisodeTracker.currentEpisodesInTrack = episodesInPodcast
        }
        
        mainView?.episodesToView = AudioEpisodeTracker.currentEpisodesInTrack

        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Segues.segueFromEpisodeToPlayer) {
            if let sendIndex = sender as? NSInteger {
                if (AudioEpisodeTracker.podcastTitle.isEmpty) {
                    AudioEpisodeTracker.episodeIndex = sendIndex
                    AudioEpisodeTracker.podcastTitle = podcastTitle
                    AudioEpisodeTracker.isPlaying = false
                }  else if (AudioEpisodeTracker.podcastTitle != podcastTitle) {
                    AudioEpisodeTracker.episodeIndex = sendIndex
                    AudioEpisodeTracker.podcastTitle = podcastTitle
                    AudioEpisodeTracker.isPlaying = false
                } else if (AudioEpisodeTracker.episodeIndex != sendIndex) {
                    AudioEpisodeTracker.episodeIndex = sendIndex
                    AudioEpisodeTracker.isPlaying = false
                } else if AudioEpisodeTracker.episodeIndex == sendIndex {
                    AudioEpisodeTracker.isPlaying = true
                }
            }
        }
    }
}

extension EpisodeController: EpisodeViewDelegate, EpisodeViewTableViewCellDelegate{
    func segueToPlayer () {
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)
    }
    
    func setSelectedEpisode(selectedEpisode: Episode, index: Int, indexPathForEpisode: IndexPath) {
        guard selectedEpisode.doucmentaudioURL == nil else {
            performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: index)
            return
        }
        
        guard  let episodeCell = self.mainView?.EpisodeTable.cellForRow(at: indexPathForEpisode) as? EpisodeViewTableViewCell  else {
            return
        }
        episodeCell.downloadAnimation.isHidden = false
        episodeCell.downloadAnimation.startAnimating()
        episodeCell.downloadStatus.text = "Downloading ..."
        ModelBridge.sharedInstance.downloadAudio((selectedEpisode.audioURL)!, result: { (downloadedPodcast) in
            
            guard downloadedPodcast != nil  else {
                DispatchQueue.main.async {
                    print("DOWNLOAD ERRRRROOOOORRRRRRRRR")
                    episodeCell.downloadAnimation.isHidden = true
                    episodeCell.downloadStatus.text = "Failed To Download"
                }
                return
            }
            
            let episode = DatabaseController.getEpisode((selectedEpisode.title)!)
            episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
            DatabaseController.saveContext()
            print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            DispatchQueue.main.async {
                episodeCell.downloadAnimation.stopAnimating()
                episodeCell.downloadStatus.text = "Downloaded"
                episodeCell.downloadAnimation.isHidden = true
                episodeCell.downloadStatus.isHidden = true
                episodeCell.accessoryType = .checkmark
            }
        })
    }
}
