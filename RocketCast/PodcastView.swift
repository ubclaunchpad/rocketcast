//
//  PodcastView.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit


class PodcastView: UIView, UITableViewDelegate, UITableViewDataSource {
    var viewDelegate: PodcastViewDelegate?
    
    @IBOutlet weak var viewTitle: UILabel!
    
    @IBOutlet weak var podcastList: UITableView!
    
    @IBAction func segueButton(sender: AnyObject) {
        viewDelegate?.segueToEpisode()
    }
    
    class func instancefromNib(frame: CGRect) -> PodcastView {
        let view = UINib(nibName: "PodcastView", bundle: nil).instantiateWithOwner(nil, options: nil)[0]
            as! PodcastView
        view.frame = frame
        view.podcastList.delegate = view
        view.podcastList.dataSource = view
        view.podcastList.allowsSelection = true
        view.podcastList.separatorStyle = UITableViewCellSeparatorStyle.None
        view.podcastList.backgroundColor = UIColor.clearColor()
        view.podcastList.opaque = false
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let podcastCell = UINib(nibName: "PodcastViewTableViewCell", bundle: nil)
        tableView.registerNib(podcastCell, forCellReuseIdentifier: "podcastCell")
        let cell = self.podcastList.dequeueReusableCellWithIdentifier("podcastCell", forIndexPath: indexPath) as! PodcastViewTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
    
        cell.tag = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell        
    }
    
    // returns an approiate number of rows depending on the section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
