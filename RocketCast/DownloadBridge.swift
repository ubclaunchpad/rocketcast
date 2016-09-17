
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
    let podcastURL = NSURL(string: url)
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(podcastURL!) {(data, response, error) in
      
      guard error == nil else {
        Log.error(error.debugDescription)
        return
      }
      let XMLString = NSString(data: data!, encoding: NSUTF8StringEncoding)
      
      let filePathAppend = "/Documents/\(url.stringByRemovingAll(stringsToRemove)).xml"
      
      let filePath = NSHomeDirectory() + filePathAppend

      do {
        try XMLString!.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        result(url: filePathAppend)
      } catch let error as NSError {
        Log.error(error.debugDescription)
      }
      
    }
    task.resume()
    
    
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
    let mp3URL = NSURL(string: url)
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(mp3URL!) {(data, response, error) in
        
        guard error == nil else {
            Log.error(error.debugDescription)
            return
        }
        let XMLString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        let filePathAppend = "/Documents/\(url.stringByRemovingAll(stringsToRemove)).mp3"
        
        let filePath = NSHomeDirectory() + filePathAppend
        
        do {
            try XMLString!.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            result(url: filePathAppend)
        } catch let error as NSError {
            Log.error(error.debugDescription)
        }
        
    }
    task.resume()
  }
  
}