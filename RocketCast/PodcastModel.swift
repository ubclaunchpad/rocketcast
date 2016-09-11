//
//  PodcastModel.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


class PodcastModel {
    private var title: String?
    private var author: String?
    private var description: String?
    private var episodes:[EpisodeModel]?
    private var imageURL:ImageWebURL?
    
    init (title: String, author:String, description: String, episodes:[EpisodeModel], imageURL:ImageWebURL) {
        self.title = title
        self.author = author
        self.description = description
        self.episodes = episodes
        self.imageURL = imageURL
    }
    
    
    
}

