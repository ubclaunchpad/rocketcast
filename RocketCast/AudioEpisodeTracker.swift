//
//  AudioEpisodeTracker+CoreDataClass.swift
//  RocketCast
//
//  Created by James Park on 2016-10-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import AVFoundation

class AudioEpisodeTracker {
    
    static var audioPlayer = AVAudioPlayer()
    static var currentTimer = Timer()
    static var isPlaying = false
    static var currentEpisodesInTrack = [Episode]()
    static var episodeIndex = -1
    static var podcastIndex = -1
    static var podcastTitle = ""
    static var episodeTitle = ""
    
    static func getCurrentEpisode() -> Episode {
        return currentEpisodesInTrack[episodeIndex]
    }
}
