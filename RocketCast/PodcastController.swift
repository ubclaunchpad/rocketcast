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
        ModelBridge.sharedInstance.downloadPodcastXML("http://billburr.libsyn.com/rss") { (downloadedPodcast) in
        }
        var dummyPodcast = PodcastModel()
        dummyPodcast.title = "dankCast"
        var dummyEpisode = EpisodeModel()
        dummyEpisode.title = "someEpisode"
        dummyPodcast.episodes?.append(dummyEpisode)
        
        savePodcast(dummyPodcast)
        showPodcast()
        
        
        
    }
    
    private func setupView() {
        let viewSize = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func savePodcast (podcast:PodcastModel) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newPodcast = NSEntityDescription.insertNewObjectForEntityForName("Podcast", inManagedObjectContext: context)
        
        
        newPodcast.setValue(podcast.title, forKey: "title")
    
    
        for episode in podcast.episodes!{
              let newEpisode = NSEntityDescription.insertNewObjectForEntityForName("Episode", inManagedObjectContext: context)
            newEpisode.setValue(episode.title, forKey: "title")
            
            let episodes = newPodcast.mutableSetValueForKey("episodes")
            episodes.addObject(newEpisode)
            
        }
        
        do {
            try context.save()
            Log.info("Saved")
        } catch {
            Log.error("Couldn't save information to data")
        }
        
    }
    
    
    private func showPodcast () {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext

        let request = NSFetchRequest(entityName: "Podcast")
    
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
               print(results)
            }
        } catch {
            Log.error("Failed")
        }    
    }
    
    
    
}
extension PodcastController:PodcastViewDelegate {
    
    func segueToEpisode() {
        performSegueWithIdentifier(Segues.segueFromPodcastToEpisode, sender: self)
    }
    
    
}
