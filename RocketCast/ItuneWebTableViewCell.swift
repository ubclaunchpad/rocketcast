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
    
    @IBOutlet weak var podcastTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
