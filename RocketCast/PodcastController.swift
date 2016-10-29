//
//  ViewController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import CoreData
@available(iOS 10.0, *)
class PodcastController: UIViewController {
    
    var podcasts = [Podcast]()
    
    var mainView: PodcastView?
    let CoreData = CoreDataHelper()
    let PodcastHelper = Podcast()
    override func viewDidLoad() {
        super.viewDidLoad()
         CoreData.deleteAllManagedObjects()
        
        _ = XMLParser(url:"https://s3-us-west-2.amazonaws.com/podcastassets/Episodes/testPodcastNoAuthorsForEpisodes.xml")

//        if (PodcastHelper.getPodcastCount() == 0) {
//            _ = XMLParser(url:"http://billburr.libsyn.com/rss")
//            
//        }
        
        setupView()
//        ModelBridge.sharedInstance.downloadPodcastXML("http://billburr.libsyn.com/rss") { (downloadedPodcast) in
//        }
        
//        
        
        
        
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        let podcastDB = Podcast(context: CoreData.persistentContainer.viewContext)
        let listOfPodcasts = podcastDB.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        for podcast in listOfPodcasts  {
            print(podcast.summary)
        }
        
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

@available(iOS 10.0, *)
extension PodcastController:PodcastViewDelegate {
    
    func segueToEpisode() {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: self)
    }
    
    func setSelectedPodcastAndSegue(selectedPodcast: Podcast) {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: selectedPodcast)
        
    }
}
