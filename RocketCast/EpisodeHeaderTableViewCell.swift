//
//  EpisodeHeaderTableViewCell.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-11-08.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class EpisodeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var podcastTitle: UILabel!
    @IBOutlet weak var podcastAuthor: UILabel!
    @IBOutlet weak var podcastSummary: UILabel!
    @IBOutlet weak var coverPhotoView: UIView!
    var listOfEpisodes = [Episode]()
    
    var podcast: Podcast! {
        didSet {
            setupPodcastInfo()
        }
    }
    
    func setupPodcastInfo() {
        let effectsLayer = coverPhotoView.layer
        effectsLayer.cornerRadius = 18
        effectsLayer.shadowColor = UIColor.black.cgColor
        effectsLayer.shadowOffset = CGSize(width: 0, height: 0)
        effectsLayer.shadowRadius = 4
        effectsLayer.shadowOpacity = 0.4
        effectsLayer.shadowPath = UIBezierPath(roundedRect: coverPhotoView.bounds, cornerRadius: coverPhotoView.layer.cornerRadius).cgPath
        
        podcastTitle.text = podcast.title
        podcastAuthor.text = podcast.author
        
        podcastSummary.text = podcast.summary
        let url = URL(string: (podcast.imageURL)!)

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
}
