
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

    func downloadPodcast(url: URL, result: (downloadedPodcast: PodcastModel) -> ()) {
        let nsURL = NSURL(string: url)
        let parser = NSXMLParser(contentsOfURL: nsURL!)
        print(parser)
        
        let xmlParser = XMLParser(url: nsURL!)
        
        //download it
        //pass the rss data to another object
        // get the authrfrom that object
        //get other info from that object (list of episodes, title of podcast)
        //put the title, episodes, and author into the POdcastModel
        
    }
    
}