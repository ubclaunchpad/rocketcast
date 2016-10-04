//
//  TableViewCell.swift
//  RocketCast
//
//  Created by Xenia Chiru on 2016-09-17.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

protocol PodcastViewTableViewCellDelegate{
}

class PodcastViewTableViewCell: UITableViewCell {
    
    var delegate: PodcastViewTableViewCellDelegate?
    
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastDescription: UILabel!
    @IBOutlet weak var podcastName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPodcastNameText(setPodcastName: NSMutableString) {
        podcastName.text = setPodcastName as String
    }
    
    func setPodcastDescriptionText(setPodcastDescription: NSMutableString) {
        podcastDescription.text = setPodcastDescription as String
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if !selected {
            podcastName.textColor = UIColor.blackColor()
        } else {
            podcastName.textColor = UIColor.redColor()
        }

    }
    
}
