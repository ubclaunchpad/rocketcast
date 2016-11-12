//
//  ItuneWebTableViewCell.swift
//  RocketCast
//
//  Created by James Park on 2016-11-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

protocol ItuneWebTableViewCellDelegate {
   
}

class ItuneWebTableViewCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(podcast: PodcastFromAPI) {
        //TODO: set image from url
        self.podcastTitle.text = podcast.podcastTitle
        guard !podcast.imageUrl.isEmpty else {
            Log.info("Image url is empty")
            return
        }
        let url = URL(string: podcast.imageUrl)
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.podcastImage.image = UIImage(data: data)
                }
            } catch let error as NSError {
                Log.error("Error: " + error.debugDescription)
            }
        }
    }

}
