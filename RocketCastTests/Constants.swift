//
//  constant.swift
//  RocketCast
//
//  Created by James Park on 2016-12-04.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

enum viewControllerIdentifier {
    static let podcastVC = "podcastcontroller"
    static let urlVC = "urlVC"
    static let episodeVC = "episodeVC"
    static let ituneVC = "ituneVC"
}


struct SamplePodcast {
    static let podcastTitle = "LaunchPad podcast testing"
    static let firstEpisode = "Monday Morning Podcast 9-12-16"
    static let secondEpisode = "Thursday Afternoon Monday Morning Podcast 9-8-16"
    static let author = "Bill Burr"
    
    static let listOfEpisodes = [firstEpisode, secondEpisode]
}


let tapToDownload = "Tap to Download"
let downloading = "Downloading ..."
