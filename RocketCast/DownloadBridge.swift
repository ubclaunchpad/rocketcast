
//
//  PodcastInterface.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

protocol DownloadBridgeProtocol {
    func downloadPodcast(url:URL, result:(downloadedPodcast: PodcastModel) -> ())
}
extension ModelBridge: DownloadBridgeProtocol {
    // TODO
    func downloadPodcast(url: URL, result: (downloadedPodcast: PodcastModel) -> ()) {
        
    }
    
}