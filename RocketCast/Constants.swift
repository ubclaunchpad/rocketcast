//
//  Constants.swift
//  RocketCast
//
//  Created by James Park on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

typealias PodcastWebURL = String
typealias ImageWebURL = String
typealias MP3WebURL = String
typealias PodcastStorageURL = String
typealias ImageStorageURL = String
typealias MP3StorageURL = String
typealias XML = String

enum  Segues {
  static let segueFromPodcastToEpisode = "segueFromPodcastToEpisode"
  static let segueFromEpisodeToPlayer = "segueFromEpisodeToPlayer"

}

struct xmlKeyTags {
    static let episodeTag = "item"
    static let podcastImage = "itunes:image"
    static let imageLink = "href"
    static let startTagMP3URL = "enclosure"
    static let mp3URL = "url"
    static let title = "title"
    static let description = "itunes:summary"
    static let author = "itunes:author"
    static let publishedDate = "pubDate"
    static let authorEpisodeTagTwo = "dc:creator"
    static let descriptionTagTwo = "description"
    static let duration = "itunes:duration"
    static let unwantedStringInTag = ["<p>", "</p>", "\t"]
}
/**
 A log level of debug will print out all levels above it.
 So a log level of WARN will print out WARN, ERROR, and TEST
 */
enum LogLevel {
    static let lvl = LogLevelChoices.DEBUG
}