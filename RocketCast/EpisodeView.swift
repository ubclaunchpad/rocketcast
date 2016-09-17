//
//  EpisodeView.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class EpisodeView: UIView {
    var viewDelegate: EpisodeViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func segueToPlayer(sender: AnyObject) {
        viewDelegate?.segueToPlayer()
    }
    class func instancefromNib(frame: CGRect) -> EpisodeView {
        let view = UINib(nibName: "EpisodeView", bundle: nil).instantiateWithOwner(nil, options: nil)[0]
            as! EpisodeView
        view.frame = frame
        return view
    }

}

