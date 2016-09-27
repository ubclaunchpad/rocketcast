
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
   
    func downloadPodcastXML(url:PodcastWebURL, result:(url: PodcastStorageURL?) -> ())
    func downloadImage(url: ImageWebURL, result:(url: ImageStorageURL) -> ())
    func downloadMp3(url: MP3WebURL, result:(url: MP3StorageURL) -> ())
}
extension ModelBridge: DownloadBridgeProtocol {
    
    func downloadPodcastXML(url:PodcastWebURL, result:(url: PodcastStorageURL?) -> ()) {
        let podcastURL = NSURL(string: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(podcastURL!) {(data, response, error) in
            
            guard error == nil else {
                Log.error(error.debugDescription)
                result(url: nil)
                return
            }
            guard let XMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                result(url: nil)
                return
            }
            
            let filePathAppend = "/Documents/\(url.stringByRemovingAll(stringsToRemove)).xml"
            
            let filePath = NSHomeDirectory() + filePathAppend
            
            do {
                try XMLString.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
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
        let urlString = String(url)
        let url = NSURL(string: urlString)
        var destinationPath = " "
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let data = NSData(contentsOfURL: url!) {//make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    let image = UIImage(data: data)
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                    destinationPath = documentsPath + urlString.stringByRemovingAll(stringsToRemove)+".png"
                    UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
                    result(url: destinationPath)
                });
            }
        }
    }
    
    func downloadMp3(url: MP3WebURL, result:(url: MP3StorageURL) -> ()) {
        //TODO
    }
    
}