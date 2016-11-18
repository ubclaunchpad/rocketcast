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
    static var currentTimerForSlider = Timer()
    static var isPlaying = false
    static var currentEpisodesInTrack = [Episode]()
    static var episodeIndex = -1
    static var podcastIndex = -1
    static var podcastTitle = ""
    static var episodeTitle = ""
    static var currentRate = speedRates.single
    static var isTheAudioEmpty = true
    
    static func getCurrentEpisode() -> Episode {
        return currentEpisodesInTrack[episodeIndex]
    }
    
    static func resetAudioTracker() {
        if isPlaying {
            audioPlayer.pause()
        }
        audioPlayer = AVAudioPlayer()
        currentEpisodesInTrack = [Episode]()
        currentTimerForSlider.invalidate()
        isPlaying = false
        episodeIndex = -1
        podcastIndex = -1
        episodeTitle = ""
        podcastTitle = ""
        isTheAudioEmpty = true
    }
    
    static func resetAudioData() {
        audioPlayer.stop()
        currentTimerForSlider.invalidate()
        audioPlayer.currentTime = 0
        audioPlayer = AVAudioPlayer()
        isTheAudioEmpty = true
    }
    
    static func loadAudioDataToAudioPlayer(_ data:Data) {
        do {
            AudioEpisodeTracker.audioPlayer = try AVAudioPlayer(data: data)
            
            AudioEpisodeTracker.audioPlayer.prepareToPlay()
            AudioEpisodeTracker.audioPlayer.enableRate = true
            AudioEpisodeTracker.isPlaying = true
            AudioEpisodeTracker.isTheAudioEmpty = false
            AudioEpisodeTracker.currentRate = speedRates.single
        } catch let error as NSError {
            Log.error(error.localizedDescription)
        }
    }
}
