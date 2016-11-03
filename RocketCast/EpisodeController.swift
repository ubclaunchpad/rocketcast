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
    var shouldReloadNewEpisodeTrack = true
    var mainView: EpisodeView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        if (shouldReloadNewEpisodeTrack) {
            currentEpisodeList = episodesInPodcast
        }
        mainView?.episodesToView = currentEpisodeList
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Segues.segueFromEpisodeToPlayer) {
            let viewController: PlayerController = segue.destination as! PlayerController
            if let sendIndex = sender as? NSInteger {
                viewController.trackId = sendIndex
            }
        }
    }
}

extension EpisodeController: EpisodeViewDelegate, EpisodeViewTableViewCellDelegate{
    func segueToPlayer () {
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)
    }
    
    func setSelectedEpisode(selectedEpisode: Episode, index: Int, indexPathForEpisode: IndexPath) {
        if selectedEpisode.doucmentaudioURL != nil {
            performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: index)
        }
        else {
            if let episodeCell = self.mainView?.EpisodeTable.cellForRow(at: indexPathForEpisode) as? EpisodeViewTableViewCell {
                episodeCell.downloadAnimation.startAnimating()
                
                ModelBridge.sharedInstance.downloadAudio((selectedEpisode.audioURL)!, result: { (downloadedPodcast) in
                    if downloadedPodcast == nil {
                        print("DOWNLOAD ERRRRROOOOORRRRRRRRR")
                    }
                    let episode = DatabaseController.getEpisode((selectedEpisode.title)!)
                    episode?.setValue(downloadedPodcast!, forKey: "doucmentaudioURL")
                    DatabaseController.saveContext()
                    print("DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    episodeCell.downloadAnimation.stopAnimating()
                    episodeCell.downloadAnimation.isHidden = true
                    episodeCell.accessoryType = .checkmark
     
                })
                
            }
            
        }
    }
    
    
    
    
    
    
}
