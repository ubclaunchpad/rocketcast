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
    lazy var podcastsToView = [Podcast]()
    
    @IBAction func segueButton(_ sender: AnyObject) {
        viewDelegate?.segueToEpisode()
    }
    
    class func instancefromNib(_ frame: CGRect) -> PodcastView {
        let view = UINib(nibName: "PodcastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! PodcastView
        view.frame = frame
        view.podcastList.delegate = view
        view.podcastList.dataSource = view
        view.podcastList.allowsSelection = true
        view.podcastList.separatorStyle = UITableViewCellSeparatorStyle.none
        view.podcastList.backgroundColor = UIColor.clear
        view.podcastList.isOpaque = false
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let podcastCell = UINib(nibName: "PodcastViewTableViewCell", bundle: nil)
        tableView.register(podcastCell, forCellReuseIdentifier: "podcastCell")
        if let cell = self.podcastList.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastViewTableViewCell {
            cell.updateUI(Podcast: podcastsToView[indexPath.row])
            cell.backgroundColor = UIColor.clear
            cell.tag = (indexPath as NSIndexPath).row
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        


        
    }
    
    // returns an approiate number of rows depending on the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  podcastsToView.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewDelegate?.setSelectedPodcastAndSegue(selectedPodcast: podcastsToView[indexPath.row])
        
    }

}
