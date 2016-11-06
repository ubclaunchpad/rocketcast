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
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func playButton(_ sender: AnyObject) {
        viewDelegate?.playPodcast()
        statusLabel.text = "Playing at 1x"
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func stopButton(_ sender: AnyObject) {
        viewDelegate?.pausePodcast()
        statusLabel.text = "Pause"
    }
    @IBAction func backButton(_ sender: AnyObject) {
        viewDelegate?.goBack()
    }
    @IBAction func skipButton(_ sender: AnyObject) {
        viewDelegate?.goForward()
    }
    
    @IBAction func changeAudio(_ sender: AnyObject) {

        if ((slider.value) == (slider.maximumValue)) {
            viewDelegate?.playNextEpisode()
        } else {
            AudioEpisodeTracker.audioPlayer.stop()
            AudioEpisodeTracker.audioPlayer.currentTime = TimeInterval(slider.value)
            AudioEpisodeTracker.audioPlayer.prepareToPlay()
            AudioEpisodeTracker.audioPlayer.play()
        }
        
       
    }
    

    @IBAction func SegueBack(_ sender: AnyObject) {
        viewDelegate?.segueBackToEpisodes()
    }
    @IBAction func changeSpeed(_ sender: UIButton) {
        viewDelegate?.changeSpeed(sender.tag)
        statusLabel.text = "Playing at \(sender.tag)x"
    }
    class func instancefromNib(_ frame: CGRect) -> PlayerView {
        let view = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! PlayerView
        view.frame = frame
        
        return view
    }
    
    func setTitles (title: String) {
        titleLabel.text = title
        descriptionView.text = "Test Description"
    }
    
    func updateUI (episode: Episode) {
        self.titleLabel.text = episode.title!
        self.descriptionView.text = "Simple description of Podcast"
        let url = URL(string: episode.imageURL!)
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
                
            } catch let error as NSError{
                Log.error("Error: " + error.debugDescription)
            }
        }
    }
    
}

