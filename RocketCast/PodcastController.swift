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
    
    var updatePodcastsButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateAllPodcasts))
    var goToItuneWebButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToItuneWeb))
    var enterDeleteModeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(toggleDeleteMode))
    
    var inDeleteMode = false {
        didSet {
            if inDeleteMode {
                let textButton = UIBarButtonItem()
                textButton.title = "Delete Mode"
                self.enterDeleteModeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(toggleDeleteMode))
                navigationItem.leftBarButtonItems = [textButton]
                navigationItem.rightBarButtonItems = [self.enterDeleteModeButton]
            } else {
                self.enterDeleteModeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(toggleDeleteMode))
                navigationItem.leftBarButtonItems = [self.updatePodcastsButton, self.goToItuneWebButton]
                navigationItem.rightBarButtonItems = [self.enterDeleteModeButton]
            }
            refreshView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inDeleteMode = false
        self.title = ""
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if AudioEpisodeTracker.isPlaying {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(segueToPlayer) )
        }
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        let listOfPodcasts = DatabaseUtil.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        mainView?.inDeleteMode = self.inDeleteMode
        
        self.updatePodcastsButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateAllPodcasts))
        self.goToItuneWebButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToItuneWeb))
        self.enterDeleteModeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(toggleDeleteMode))
        
        navigationItem.leftBarButtonItems = [self.updatePodcastsButton, self.goToItuneWebButton]
        navigationItem.rightBarButtonItems = [self.enterDeleteModeButton]
        
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    fileprivate func refreshView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        let listOfPodcasts = DatabaseUtil.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        mainView?.inDeleteMode = self.inDeleteMode
        
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
                destination.selectedPodcast = podcast
            }
        }
    }
}
extension PodcastController:PodcastViewDelegate {

    func segueToPlayer() {
        guard !AudioEpisodeTracker.isTheAudioEmpty else {
            return
        }
        performSegue(withIdentifier: Segues.segueFromPodcastListToPlayer, sender: self)
    }
    
    func setSelectedPodcastAndSegue(selectedPodcast: Podcast) {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: selectedPodcast)
    }
    
    func toggleDeleteMode() {
        self.inDeleteMode = !self.inDeleteMode
    }
    
    func deletePodcast(Podcast: Podcast){
        DatabaseUtil.deletePodcast(podcastTitle: Podcast.title!)
        refreshView()
    }
    
    func updateAllPodcasts() {
        
        AudioEpisodeTracker.resetAudioTracker()
        var currentPodcasts =  DatabaseUtil.getAllPodcasts()
        while (!currentPodcasts.isEmpty) {
            if let podcast = currentPodcasts.popLast() {
                if let rssFeedURL = podcast.rssFeedURL {
                    DatabaseUtil.deletePodcast(podcastTitle: podcast.title!)
                    CoreDataXMLParser(url:rssFeedURL)
                }
            }
        }
        navigationItem.rightBarButtonItems = [self.enterDeleteModeButton]
        
        let listOfPodcasts = DatabaseUtil.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        self.mainView?.podcastView.reloadData()
    }
    
    func segueToItuneWeb() {
        performSegue(withIdentifier: Segues.segueToItuneWeb, sender: self)

    }
}
