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
    
    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastAuthor: UILabel!
    @IBOutlet weak var podcastSummary: UILabel!
    @IBOutlet weak var coverPhotoView: UIView!
    
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
        view.EpisodeTable.separatorStyle = UITableViewCellSeparatorStyle.none
        view.EpisodeTable.backgroundColor = UIColor.clear
        view.EpisodeTable.isOpaque = false
        return view
    }
    
    func setupPodcastInfo() {
        let effectsLayer = coverPhotoView.layer
        effectsLayer.cornerRadius = 18
        effectsLayer.shadowColor = UIColor.black.cgColor
        effectsLayer.shadowOffset = CGSize(width: 0, height: 0)
        effectsLayer.shadowRadius = 4
        effectsLayer.shadowOpacity = 0.4
        effectsLayer.shadowPath = UIBezierPath(roundedRect: coverPhotoView.bounds, cornerRadius: coverPhotoView.layer.cornerRadius).cgPath
        
        let podcastEpisode = AudioEpisodeTracker.currentEpisodesInTrack.first
        podcastTitle.text = podcastEpisode?.podcastTitle
        podcastAuthor.text = podcastEpisode?.author
        podcastSummary.text = podcastEpisode?.summary
        let url = URL(string: (podcastEpisode?.imageURL)!)
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url!)
                let coverPhoto = UIImageView()
                coverPhoto.frame = self.coverPhotoView.bounds
                coverPhoto.layer.cornerRadius = 18
                coverPhoto.layer.masksToBounds = true
                DispatchQueue.main.async {
                    coverPhoto.image = UIImage(data: data)
                    self.coverPhotoView.addSubview(coverPhoto)
                }
                
            } catch let error as NSError{
                Log.error("Error: " + error.debugDescription)
            }
        }
    }
    
    // returns an approiate number of rows depending on the section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodesToView.count
    }
    
    // Iiterates over every episode and creates a respective TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        
        let nib_name = UINib(nibName: EpisodeViewConstants.cellViewNibName, bundle:nil)
        tableView.register(nib_name, forCellReuseIdentifier: EpisodeViewConstants.cellViewIdentifier)
        let cell = self.EpisodeTable.dequeueReusableCell(withIdentifier: EpisodeViewConstants.cellViewIdentifier, for: indexPath) as! EpisodeViewTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.episodeHeader.text = episodesToView[indexPath.row].title
        cell.tag = (indexPath as NSIndexPath).row
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if episodesToView[indexPath.row].doucmentaudioURL != nil {
            cell.downloadAnimation.isHidden = true
            cell.accessoryType = .checkmark
            cell.downloadStatus.isHidden = true
        } else {
             cell.downloadStatus.isHidden = false
             cell.accessoryType = .none
        }
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewDelegate?.setSelectedEpisode(selectedEpisode: episodesToView[indexPath.row], index: indexPath.row, indexPathForEpisode: indexPath)

    }

    
}

