//
//  EpisodePopUpController.swift
//  RocketCast
//
//  Created by Tassilo von Gerlach on 2017-02-10.
//  Copyright © 2017 UBCLaunchPad. All rights reserved.
//

import UIKit


class EpisodePopUpController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        
    
    }
    
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
