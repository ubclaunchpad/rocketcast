//
//  EpisodeController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class EpisodeController: UIViewController {

    var mainView: EpisodeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let viewSize = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
