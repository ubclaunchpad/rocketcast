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
    
    class func instancefromNib(frame: CGRect) -> PlayerView {
        let view = UINib(nibName: "PlayerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0]
            as! PlayerView
        view.frame = frame
        return view
    }
    
}

