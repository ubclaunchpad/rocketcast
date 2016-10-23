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
    
    var mainView: EpisodeView?
    var coreData = CoreDataHelper()
    var sendIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        mainView?.episodesToView = episodesInPodcast
        
       currentEpisodeList = episodesInPodcast

        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Segues.segueFromEpisodeToPlayer) {
            let viewController: PlayerController = segue.destination as! PlayerController
            viewController.trackId = sendIndex
        }
    }
}

extension EpisodeController: EpisodeViewDelegate{
    func segueToPlayer () {
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)
    }
    
    func setSelectedEpisode (selectedEpisode: Episode, index: Int) {
        let url = selectedEpisode.audioURL
        sendIndex = index
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)

    }
    
}
