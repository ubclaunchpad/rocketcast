//
//  EpisodeModel.swift
//  RocketCast
//
//  Created by James Park on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


class EpisodeModel {
    
    var title: String?
    var description:String?
    var date:String?
    var author:String?
    var duration:String?
    var imageURL:ImageWebURL?
    var mp3URL:MP3WebURL?
    
    init(title:String, description:String, date:String, author:String, duration:String, imageURL:ImageWebURL, mp3URL:MP3WebURL) {
        self.title = title
        self.description = description
        self.date = date
        self.author = author
        self.duration = duration
        self.imageURL = imageURL
        self.mp3URL = mp3URL
    }
}