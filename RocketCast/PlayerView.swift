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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var coverPhotoView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButton(_ sender: AnyObject) {
        isPlaying = !isPlaying
    }
    
    @IBOutlet weak var slider: UISlider!
    var sliderIsMoving = false
    
    var isPlaying = true {
        didSet {
            if isPlaying {
                playButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
                viewDelegate?.playPodcast()
                statusLabel.text = "Playing at \(Int(AudioEpisodeTracker.currentRate))x"
            } else {
                playButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
                viewDelegate?.pausePodcast()
                statusLabel.text = "Pause"
            }
        }
    }
    @IBAction func backButton(_ sender: AnyObject) {
        viewDelegate?.goBack()
    }
    @IBAction func skipButton(_ sender: AnyObject) {
        viewDelegate?.goForward()
    }
    
    @IBAction func changeAudio(_ sender: AnyObject) {
        // Smooths slider by reducing logic performed during each continuous slide
        if sliderIsMoving {
            // Once slider is let go
            sliderIsMoving = false
            slider.isContinuous = true
            
            guard slider.value != slider.maximumValue else {
                viewDelegate?.playNextEpisode()
                return
            }
            AudioEpisodeTracker.audioPlayer.stop()
            AudioEpisodeTracker.audioPlayer.currentTime = TimeInterval(slider.value)
            AudioEpisodeTracker.audioPlayer.prepareToPlay()
            AudioEpisodeTracker.audioPlayer.play()

        } else {
            // Initial slide value
            sliderIsMoving = true
            slider.isContinuous = false
        }
    }
    
    @IBAction func changeSpeed(_ sender: UIButton) {
        let speed = viewDelegate?.changeSpeed()
        speedButton.setTitle("\(speed!)x", for: .normal)
        statusLabel.text = "Playing at \(speed!)x"
    }
    class func instancefromNib(_ frame: CGRect) -> PlayerView {
        let view = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! PlayerView // swiftlint:disable:this force_cast
        view.frame = frame
        return view
    }
    
    func setStyling() {
        let effectsLayer = coverPhotoView.layer
        effectsLayer.cornerRadius = 14
        effectsLayer.shadowColor = UIColor.black.cgColor
        effectsLayer.shadowOffset = CGSize(width: 0, height: 0)
        effectsLayer.shadowRadius = 4
        effectsLayer.shadowOpacity = 0.4
        effectsLayer.shadowPath = UIBezierPath(roundedRect: coverPhotoView.bounds, cornerRadius: coverPhotoView.layer.cornerRadius).cgPath
    }
    
    func setTitles (title: String) {
        titleLabel.text = title
        descriptionView.text = "Test Description"
    }
    
    func updateUI (episode: Episode) {
        speedButton.setTitle("\(Int(AudioEpisodeTracker.currentRate))x", for: .normal)
        isPlaying = AudioEpisodeTracker.isPlaying
        self.titleLabel.text = episode.title!
        self.podcastTitleLabel.text = episode.podcastTitle
        self.descriptionView.text = "Simple description of Podcast"
        let url = URL(string: episode.imageURL!)
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url!)
                let coverPhoto = UIImageView()
                coverPhoto.frame = self.coverPhotoView.bounds
                coverPhoto.layer.cornerRadius = 14
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

class MediaSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}
