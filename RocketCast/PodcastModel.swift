//
//  PodcastModel.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


struct PodcastModel {
    
    var title:NSMutableString?
    var author:NSMutableString?
    var description:NSMutableString?
    var episodes:[EpisodeModel]?
    var imageURL:ImageWebURL?

    init() {
        
    }
    
    init(setTitle: NSMutableString, setDescription: NSMutableString) {
        title = setTitle
        description = setDescription
    }
}

