//
//  EpisodeView.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import CoreData

class EpisodeView: UIView, UITableViewDelegate,  UITableViewDataSource {
    var viewDelegate: EpisodeViewDelegate?
    
    lazy var episodesToView = [Episode]()
    
    @IBOutlet weak var EpisodeTable: UITableView!
    
    @IBAction func segueToPlayer(_ sender: AnyObject) {
        viewDelegate?.segueToPlayer()
    }
    class func instancefromNib(_ frame: CGRect) -> EpisodeView {
        let view = UINib(nibName: "EpisodeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! EpisodeView
        view.frame = frame
        view.EpisodeTable.delegate = view
        view.EpisodeTable.dataSource = view
        view.EpisodeTable.allowsSelection = true
        view.EpisodeTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        view.EpisodeTable.separatorColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        view.EpisodeTable.backgroundColor = UIColor.clear
        view.EpisodeTable.isOpaque = false
        view.EpisodeTable.tableFooterView = UIView(frame: CGRect.zero)
        return view
    }
    
    // returns an approiate number of rows depending on the section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return episodesToView.count
        }
    }
    
    // Iiterates over every episode and creates a respective TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        
        if indexPath.section == 0 {
            let nib_name = UINib(nibName: "EpisodeHeaderTableViewCell", bundle:nil)
            tableView.register(nib_name, forCellReuseIdentifier: "EpisodeHeaderTableViewCell")
            let cell = self.EpisodeTable.dequeueReusableCell(withIdentifier: "EpisodeHeaderTableViewCell", for: indexPath) as! EpisodeHeaderTableViewCell
            cell.setupPodcastInfo()
            cell.isUserInteractionEnabled = false
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        } else {
            let nib_name = UINib(nibName: EpisodeViewConstants.cellViewNibName, bundle:nil)
            tableView.register(nib_name, forCellReuseIdentifier: EpisodeViewConstants.cellViewIdentifier)
            let cell = self.EpisodeTable.dequeueReusableCell(withIdentifier: EpisodeViewConstants.cellViewIdentifier, for: indexPath) as! EpisodeViewTableViewCell
            
            let episode = episodesToView[indexPath.row]
            
            cell.backgroundColor = UIColor.clear
            cell.episodeHeader.text = episode.title
            cell.episodeInformation.text = "\(episode.getDate()) - \(episode.getDuration())"
            cell.episodeSummary.text = episode.summary
            cell.tag = (indexPath as NSIndexPath).row
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.tintColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0.3294117647, alpha: 1)
            if episode.doucmentaudioURL != nil {
                cell.downloadAnimation.isHidden = true
                cell.accessoryType = .checkmark
                
                cell.downloadStatus.isHidden = true
            } else {
                cell.downloadStatus.isHidden = false
                cell.accessoryType = .none
            }
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 94
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewDelegate?.setSelectedEpisode(selectedEpisode: episodesToView[indexPath.row], index: indexPath.row, indexPathForEpisode: indexPath)
        }
        
    }
}

