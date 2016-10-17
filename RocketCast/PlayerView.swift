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
    var audioURL:String?
    @IBAction func playButton(_ sender: AnyObject) {
        viewDelegate?.playPodcast()
    }
    
    @IBAction func stopButton(_ sender: AnyObject) {
        viewDelegate?.pausePodcast()
    }
    
    @IBAction func SegueBack(_ sender: AnyObject) {
        viewDelegate?.segueBackToEpisodes()
    }
    @IBAction func changeSpeed(_ sender: UIButton) {
        viewDelegate?.changeSpeed(sender.tag)
    }
    class func instancefromNib(_ frame: CGRect) -> PlayerView {
        let view = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! PlayerView
        view.frame = frame
        
        return view
    }
    
    // viewDidLoad for views
    override func willMove(toSuperview newSuperview: UIView?) {
        //viewDelegate?.setUpPlayer()
        titleLabel.text = "Test Title"
        descriptionView.text = "Test Description"

    }
    
}

