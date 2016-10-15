
//
//  PodcastInterface.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



protocol DownloadBridgeProtocol {
   
    func downloadPodcastXML(url:PodcastWebURL, result:@escaping (_ url: PodcastStorageURL?)  -> ())
    func downloadImage(url: ImageWebURL, result:(_ url: ImageStorageURL) -> ())
    func downloadAudio(url: AudioWebURL, result:(_ url: AudioStorageURL?) -> ())
}
extension ModelBridge: DownloadBridgeProtocol {

    
    func downloadPodcastXML(url:PodcastWebURL, result:@escaping (_ url: PodcastStorageURL?) -> ()) {
        let podcastURL = NSURL(string: url)
        
        let task = URLSession.sharedSession.dataTaskWithURL(podcastURL! as URL) {(data, response, error) in
            
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
    
    func downloadImage(url: ImageWebURL, result:(_ url: ImageStorageURL) -> ()) {
        let urlString = String(url)
        let url = NSURL(string: urlString!)
        var destinationPath = " "
        
        dispatch_async(dispatch_get_global_queue(DispatchQueue.GlobalQueuePriority.default, 0)) {
            if let data = NSData(contentsOfURL: url!) {//make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_get_main_queue().asynchronously(execute: {
                    let image = UIImage(data: data)
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .UserDomainMask, true)[0] as String
                    destinationPath = documentsPath + urlString?.stringByRemovingAll(stringsToRemove)+".png"
                    UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
                    result(destinationPath)
                });
            }
        }
    }
    
    func downloadAudio(url: AudioWebURL, result:@escaping (_ url: AudioStorageURL?) -> ()) {
        let audioURL = NSURL(string: url)
        let audioAsset = AVAsset(URL: audioURL! as URL)
        
        guard audioAsset.playable && audioAsset.readable else {
            Log.error("File at given URL cannot be read or played")
            result(nil)
            return
        }
        
        let task = URLSession.sharedSession().dataTaskWithURL(audioURL!) {(data, response, error) in
            
            guard error == nil else {
                Log.error(error.debugDescription)
                result(nil)
                return
            }
            
            let filePathAppend = "/Documents/\(url.stringByRemovingAll(stringsToRemove))"
            let filePath = NSHomeDirectory() + filePathAppend
            
            do {
                try data!.writeToFile(filePath, atomically: true)
                result(url: filePathAppend)
            } catch let error as NSError {
                Log.error(error.debugDescription)
            }
            
        }
        task.resume()
    }
}
