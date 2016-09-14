//
//  EpisodeModel.swift
//  RocketCast
//
//  Created by James Park on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


struct EpisodeModel {
    

    var title = NSMutableString()
    var description = NSMutableString()
    var date = NSMutableString()
    var author = NSMutableString()
    var duration = NSMutableString()
    var imageURL = ImageWebURL()
    var mp3URL = MP3WebURL()
    
    init() {
        
    }
}