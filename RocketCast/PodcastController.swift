//
//  ViewController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import CoreData
class PodcastController: UIViewController {
    
    var mainView: PodcastView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        let listOfPodcasts = DatabaseController.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToAddUrl))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateAllPodcasts))
        
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EpisodeController {
            if let podcast = sender as? Podcast {
                let episodes = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
                destination.episodesInPodcast = episodes
                destination.podcastTitle = podcast.title!
            }
        }
    }
}
extension PodcastController:PodcastViewDelegate {
    
    func segueToAddUrl() {
        performSegue(withIdentifier: Segues.segueFromPodcastListToAddUrl, sender: self)
    }
    
    func segueToEpisode() {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: self)
    }
    
    func setSelectedPodcastAndSegue(selectedPodcast: Podcast) {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: selectedPodcast)
    }
    
    func updateAllPodcasts() {
        AudioEpisodeTracker.resetAudioTracker()
        var currentPodcasts =  DatabaseController.getAllPodcasts()
        while (!currentPodcasts.isEmpty) {
            if let podcast = currentPodcasts.popLast() {
                if let rssFeedURL = podcast.rssFeedURL {
                    XMLParser(url:rssFeedURL)
                    if (XMLParser.didItSucceed()) {
                        DatabaseController.deletePodcast(podcastTitle: podcast.title!)
                    }
                }
            }
        }
        self.setupView()
        self.mainView?.podcastList.reloadData()
    }
}
