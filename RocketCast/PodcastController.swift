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
    
    var podcasts = [String]()
    
    var mainView: PodcastView?
    let CoreData = CoreDataHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

//        ModelBridge.sharedInstance.downloadPodcastXML("http://billburr.libsyn.com/rss") { (downloadedPodcast) in
//        }
//        
        
    //    _ = XMLParser(url:"http://billburr.libsyn.com/rss")
        
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
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
        cell.textLabel?.text = (podcasts[(indexPath as NSIndexPath).row])
        return cell
    }
}

@available(iOS 10.0, *)
extension PodcastController:PodcastViewDelegate {
    
    func segueToEpisode() {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: self)
    }
}
