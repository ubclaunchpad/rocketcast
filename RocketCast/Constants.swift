//
//  Constants.swift
//  RocketCast
//
//  Created by James Park on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

typealias PodcastURL = String
typealias ImageURL = String
typealias MP3URL = String
typealias XML = String

enum  Segues {
  static let segueFromPodcastToEpisode = "segueFromPodcastToEpisode"
  static let segueFromEpisodeToPlayer = "segueFromEpisodeToPlayer"

}

/**
 A log level of debug will print out all levels above it.
 So a log level of WARN will print out WARN, ERROR, and TEST
 */
enum LogLevel {
    static let lvl = LogLevelChoices.DEBUG
}