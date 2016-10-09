//
//  PlayerView.swift
//  RocketCast
//
//  Created by Odin and QuantumSpark on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    var viewDelegate: PlayerViewDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBAction func playButton(sender: AnyObject) {
        viewDelegate?.playPodcast()
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        viewDelegate?.pausePodcast()
    }
    
    @IBAction func changeSpeed(sender: UIButton) {
        viewDelegate?.changeSpeed(sender.tag)
    }
    class func instancefromNib(frame: CGRect) -> PlayerView {
        let view = UINib(nibName: "PlayerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0]
            as! PlayerView
        view.frame = frame
        return view
    }
    
    // viewDidLoad for views
    override func willMoveToSuperview(newSuperview: UIView?) {
        viewDelegate?.setUpPlayer()
        titleLabel.text = "Test Title"
        descriptionView.text = "Test Description"

    }
    
}

