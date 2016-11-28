//
//  AddUrlView.swift
//  RocketCast
//
//  Created by Mohamed Ali on 2016-10-29.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class AddUrlView: UIView {
    
    var viewDelegate: AddUrlViewDelegate?

    @IBOutlet weak var inputUrl: UITextField!

    class func instancefromNib(_ frame: CGRect) -> AddUrlView {
        let view = UINib(nibName: "AddUrlView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! AddUrlView
        view.frame = frame
        return view
    }

    @IBAction func addPodcastBtnPressed(_ sender: AnyObject) {
        if let url = inputUrl.text {
            viewDelegate?.addPodcast(webUrl: url)
        }
    }
}
