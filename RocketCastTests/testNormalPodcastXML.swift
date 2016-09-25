//
//  testNormalPodcastXML.swift
//  RocketCast
//
//  Created by James Park on 2016-09-12.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

struct testNormalPodcastXML {
    
    let fileName = "testNormalPodcastXML"
    
    let title = "QuantumSpark's podcast"
    let author = "James Park"
    let description = "A dank podcast"
    let imageURL = "JamesPark.jpg"
    
   private let expectedEpisode1:[String:String] =
        [ "title" : "Quantum Superposition",
          "description": "exploring states of particles",
          "author" : "Jon Mercer",
          "date": "2016-09-22 19:40:49 +0000",
          "duration" : "01:07:59",
          "image" : "JONMERCER.jpg",
          "mp3" : "http://www.yourserver.com/podcast_fileONE.mp3"]
    
    
    private let expectedEpisode2:[String:String] =
        [ "title" : "Photon",
          "description": "lights",
          "author" : "Kelvin Chan",
          "date": "2016-09-21 19:40:49 +0000",
          "duration" : "12:07:59",
          "image" : "KELVINCHAN.jpg",
          "mp3" : "http://www.yourserver.com/podcast_fileTWO.mp3"]
    
    var expectedEpisodes = [[String:String]]()
    
    init () {
        expectedEpisodes.append(expectedEpisode1)
        expectedEpisodes.append(expectedEpisode2)
    }
    
    
}
