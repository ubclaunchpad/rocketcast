//
//  EpisodePopUpController.swift
//  RocketCast
//
//  Created by Tassilo von Gerlach on 2017-02-10.
//  Copyright © 2017 UBCLaunchPad. All rights reserved.
//

import UIKit


class EpisodePopUpController: UIViewController {
    
    var episodeDescription: String?
    var episodeTitle: String?
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 0)
        popUpView.layer.shadowOpacity = 0.25
        popUpView.layer.shadowRadius = 5.0
        
        titleLabel.text = episodeTitle ?? ""
        descriptionTextView.text = episodeDescription ?? ""
        
    }
    
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
       
        Log.test(descriptionTextView.text!)
    }
    
}
