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
    
    var podcasts = []
    
    var mainView: PodcastView?
    let CoreData = CoreDataHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        ModelBridge.sharedInstance.downloadPodcastXML("http://billburr.libsyn.com/rss") { (downloadedPodcast) in
        }
        
        
        //_ = XMLParser(url:"http://billburr.libsyn.com/rss")
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = (podcasts[indexPath.row] as! String)
        return cell
    }
}

extension PodcastController:PodcastViewDelegate {
    
    func segueToEpisode() {
        performSegueWithIdentifier(Segues.segueFromPodcastToEpisode, sender: self)
    }
}


//
//extension EpisodeController: UITableViewDelegate, UITableViewDataSource {
//    
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
//        
//        cell.textLabel?.text = episodes[indexPath.row]
//        
//        return cell
//    }
//}