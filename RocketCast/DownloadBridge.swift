
//
//  PodcastInterface.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit

protocol DownloadBridgeProtocol {

    func downloadPodcastXML(url:PodcastWebURL, result:(url: PodcastStorageURL) -> ())
    func downloadImage(url: ImageWebURL, result:(url: ImageStorageURL) -> ())
    func downloadMp3(url: MP3WebURL, result:(url: MP3StorageURL) -> ())
}
extension ModelBridge: DownloadBridgeProtocol {

    func downloadPodcastXML(url:PodcastWebURL, result:(url: PodcastStorageURL) -> ()) {
        let nsURL = NSURL(string: url)
        let parser = NSXMLParser(contentsOfURL: nsURL!)
        print(parser)
        
        _ = XMLParser(url: url)
        
    
        //download it
        //pass the rss data to another object
        // get the authrfrom that object
        //get other info from that object (list of episodes, title of podcast)
        //put the title, episodes, and author into the POdcastModel
        
    }
    
    func downloadImage(url: ImageWebURL, result:(url: ImageStorageURL) -> ()) {
        //TODO
    }
    
    func downloadMp3(url: MP3WebURL, result:(url: MP3StorageURL) -> ()) {
        //TODO
    }
    
}