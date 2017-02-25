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
    var selectedPodcast: Podcast!
    var mainView: EpisodeView?
    var dataToPassToPopUpController: Episode!
    
    override func viewDidLoad() {
        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if AudioEpisodeTracker.isPlaying {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(segueToPlayer) )
        }
        
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        mainView?.podcast = selectedPodcast
        mainView?.episodesToView = episodesInPodcast
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
                    AudioEpisodeTracker.podcastTitle = selectedPodcast.title!
                    AudioEpisodeTracker.isPlaying = false
                }  else if (AudioEpisodeTracker.podcastTitle != selectedPodcast.title!) {
                    AudioEpisodeTracker.episodeIndex = sendIndex
                    AudioEpisodeTracker.podcastTitle = selectedPodcast.title!
                    AudioEpisodeTracker.isPlaying = false
                } else if (AudioEpisodeTracker.episodeIndex != sendIndex) {
                    AudioEpisodeTracker.episodeIndex = sendIndex
                    AudioEpisodeTracker.isPlaying = false
                } else if AudioEpisodeTracker.episodeIndex == sendIndex {
                    AudioEpisodeTracker.isPlaying = true
                }
            }
        }
        if (segue.identifier == Segues.segueFromEpisodeToPopUp) {
            let nextSegue = (segue.destination as! EpisodePopUpController)
            var temp = dataToPassToPopUpController.description
            nextSegue.someText = dataToPassToPopUpController.description
            
        }
    }
}

extension EpisodeController: EpisodeViewDelegate, EpisodeViewTableViewCellDelegate{
  
    func segueToPlayer () {
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)
    }
    
    func callSegueFromCell(myData dataobject: AnyObject){
        dataToPassToPopUpController = dataobject as! Episode
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EpisodePopUpController") as! EpisodePopUpController
        let data = dataobject as! Episode
        let title = data.title
        let description = data.summary
        vc.someText = description!
        self.present(vc, animated: true, completion: nil)
//        performSegue(withIdentifier: Segues.segueFromEpisodeToPopUp, sender: self)

    }
    
    func setSelectedEpisode(selectedEpisode: Episode, index: Int, indexPathForEpisode: IndexPath) {
    
        guard selectedEpisode.doucmentaudioURL == nil else {
            AudioEpisodeTracker.currentEpisodesInTrack = episodesInPodcast
            performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: index)
            return
        }
        
        guard  let episodeCell = self.mainView?.EpisodeTable.cellForRow(at: indexPathForEpisode) as? EpisodeViewTableViewCell  else {
            return
        }
        episodeCell.downloadAnimation.isHidden = false
        episodeCell.downloadAnimation.startAnimating()
        Log.info("Starting to downloading")
        episodeCell.downloadStatus.text = "Downloading ..."
        ModelBridge.sharedInstance.downloadAudio((selectedEpisode.audioURL)!, result: { (downloadedPodcast) in
            
            guard downloadedPodcast != nil  else {
                DispatchQueue.main.async {
                    Log.info("DOWNLOAD ERRRRROOOOORRRRRRRRR")
                    episodeCell.downloadAnimation.isHidden = true
                    episodeCell.downloadStatus.text = "Failed To Download"
                }
                return
            }
            
            guard let episodeTitle = selectedEpisode.title else {
                Log.info("Empty episode title. The podcast got deleted")
                return
            }
            
            let episode = DatabaseController.getEpisode(episodeTitle as String)
            episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
            DatabaseController.saveContext()
            Log.info("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
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


