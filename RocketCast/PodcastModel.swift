//
//  PodcastModel.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


class PodcastModel {
    
    var title:NSMutableString?
    var description:NSMutableString?
  //  var episodes:[EpisodeModel]?
    var imageURL:ImageWebURL?
    
    init () {
        title = ""
        description = ""
    //    episodes = [EpisodeModel]()
        imageURL = ""
    //    self.xml = xml
    }
    
    private var xml: String?
    
    //podcast info
    //podcast episodes
    
//    init (xml: XML) {
//        self.xml = xml
//    }
    
    init(setTitle: NSMutableString, setDescription: NSMutableString) {
        title = setTitle
        description = setDescription
       // episodes = ""
        imageURL = ""
    }
    
}

