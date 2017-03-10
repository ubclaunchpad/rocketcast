//
//  EpisodeViewTableViewCell.swift
//  RocketCast
//
//  Created by Admin on 2016-09-24.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

protocol EpisodeViewTableViewCellDelegate{
 //   func updateAnimation()
    func callSegueFromCell(myData dataobject: AnyObject)
}

class EpisodeViewTableViewCell: UITableViewCell {
    @IBOutlet weak var episodeHeader: UILabel!
    @IBOutlet weak var downloadAnimation: UIActivityIndicatorView!
    @IBOutlet weak var episodeInformation: UILabel!
    @IBOutlet weak var episodeSummary: UILabel!
    
    
    @IBOutlet weak var downloadStatus: UILabel!
    var delegate: EpisodeViewTableViewCellDelegate?
    var episode: Episode!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setEpisodeHeaderText(_ setHeader: NSMutableString) {
        episodeHeader.text = setHeader as String
    }
    
    
    @IBAction func showMoreInformation(_ sender: Any) {
        
        if(self.delegate != nil){ //Just to be safe.
            self.delegate?.callSegueFromCell(myData: episode)
        }
        
    }
    
    
}


