//
//  PodcastView.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit

class PodcastView: UIView {
    
    var viewDelegate: PodcastViewDelegate?
    
    class func instancefromNib(frame: CGRect) -> PodcastView {
        let view = UINib(nibName: "PodcastView", bundle: nil).instantiateWithOwner(nil, options: nil)[0]
            as! PodcastView
        view.frame = frame
        return view
    }
}