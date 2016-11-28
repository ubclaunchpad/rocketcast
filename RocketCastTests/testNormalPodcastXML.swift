//
//  testNormalPodcastXML.swift
//  RocketCast
//
//  Created by James Park on 2016-09-12.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

struct testNormalPodcastXML { // swiftlint:disable:this force_cast
    
    let fileName = "testNormalPodcastXML"
    
    let title = "QuantumSpark's podcast"
    let author = "James Park"
    let description = "A dank podcast"
    let imageURL = "JamesPark.jpg"
    
let expectedEpisode1:[String:String] =
        [ "title" : "Quantum Superposition",
          "description": "exploring states of particles",
          "author" : "Jon Mercer",
          "date": "2016-11-10 21:26:18 +0000",
          "duration" : "01:07:59",
          "image" : "JONMERCER.jpg",
          "audio" : "http://www.yourserver.com/podcast_fileONE.mp3"]
    
    
 let expectedEpisode2:[String:String] =
        [ "title" : "Photon's Dog",
          "description": "lights",
          "author" : "Kelvin Chan",
          "date": "2016-09-21 19:40:49 +0000",
          "duration" : "12:07:59",
          "image" : "KELVINCHAN.jpg",
          "audio" : "http://www.yourserver.com/podcast_fileTWO.mp3"]
    
    var expectedEpisodes = [[String:String]]()
    
    init () {
        expectedEpisodes.append(expectedEpisode1)
        expectedEpisodes.append(expectedEpisode2)
    }
    
    
}
