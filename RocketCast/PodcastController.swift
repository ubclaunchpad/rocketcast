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
    
    var podcasts = [Podcast]()
    
    var mainView: PodcastView?
    let PodcastHelper = Podcast()
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (DatabaseController.getPodcastCount() == 0) {
//            _ = XMLParser(url:"http://billburr.libsyn.com/rss")
//
//        }
        setupView()
  
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        let listOfPodcasts = DatabaseController.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        for podcast in listOfPodcasts  {
            print(podcast.summary)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToAddUrl))
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (podcasts[(indexPath as NSIndexPath).row].title!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EpisodeController {
            if let podcast = sender as? Podcast {
                let episodes = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
                destination.episodesInPodcast = episodes
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
}
