//
//  testPodcastNoAuthorsForEpisodes.swift
//  RocketCast
//
//  Created by James Park on 2016-09-13.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


struct testPodcastNoAuthorsForEpisodes { // swiftlint:disable:this force_cast
    
    let fileName = "testPodcastNoAuthorsForEpisodes"
    
    let title = "Monday Morning Podcast"
    let author = "Bill Burr"
    let description = "Bill Burr rants about relationship advice, sports and the Illuminati."
    let imageURL = "http://static.libsyn.com/p/assets/4/7/9/b/479b005a1d9a6fe6/Burr_image-062.jpg"
    
let expectedEpisode1:[String:String] =
        [ "title" : "Monday Morning Podcast 9-12-16",
          "description": "Bill rambles about football, strip clubs and quitting on stage.",
          "author" : "Bill Burr",
          "date": "2016-09-13 05:05:59 +0000",
          "duration" : "01:03:52",
          "image" : "http://static.libsyn.com/p/assets/4/7/9/b/479b005a1d9a6fe6/Burr_image-062.jpg",
          "audio" : "http://traffic.libsyn.com/billburr/MMPC_9-12-16.mp3"]
    
    
let expectedEpisode2:[String:String] =
        [ "title" : "Thursday Afternoon Monday Morning Podcast 9-8-16",
          "description": "Bill rambles about Sully, The East Side Comedy Club and having 9 kids.",
          "author" : "Bill Burr",
          "date": "2016-09-08 21:28:15 +0000",
          "duration" : "01:07:59",
          "image" : "http://static.libsyn.com/p/assets/4/7/9/b/479b005a1d9a6fe6/Burr_image-062.jpg",
          "audio" : "http://traffic.libsyn.com/billburr/TAMMP_9-8-16.mp3"]
    
    var expectedEpisodes = [[String:String]]()
    
    init () {
        expectedEpisodes.append(expectedEpisode1)
        expectedEpisodes.append(expectedEpisode2)
    }
    
    
}
