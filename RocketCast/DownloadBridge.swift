
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
   
    func downloadPodcastXML(_ url:PodcastWebURL, result:@escaping (_ url: PodcastStorageURL?) -> ())
    func downloadImage(_ url: ImageWebURL, result:@escaping (_ url: ImageStorageURL) -> ())
    func downloadAudio(_ url: AudioWebURL, result:@escaping (_ url: AudioStorageURL?) -> ())
}
extension ModelBridge: DownloadBridgeProtocol {

    
    func downloadPodcastXML(_ url:PodcastWebURL, result:@escaping (_ url: PodcastStorageURL?) -> ()) {
        let podcastURL = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: podcastURL!, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                Log.error(error.debugDescription)
                result(nil)
                return
            }
            guard let XMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) else {
                result(nil)
                return
            }
            
            let filePathAppend = "/Documents/\(url.stringByRemovingAll(stringsToRemove)).xml"
            
            let filePath = NSHomeDirectory() + filePathAppend
            
            do {
                try XMLString.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8.rawValue)
                result(filePathAppend)
            } catch let error as NSError {
                Log.error(error.debugDescription)
            }
            
        }) 
        task.resume()
        
        
    
        //download it
        //pass the rss data to another object
        // get the authrfrom that object
        //get other info from that object (list of episodes, title of podcast)
        //put the title, episodes, and author into the POdcastModel
        
    }
    
    func downloadImage(_ url: ImageWebURL, result:@escaping (_ url: ImageStorageURL) -> ()) {
        let urlString = String(url)
        let url = URL(string: urlString!)
        var destinationPath = " "
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            if let data = try? Data(contentsOf: url!) {//make sure your image in this url does exist, otherwise unwrap in a if let check
                DispatchQueue.main.async(execute: {
                    let image = UIImage(data: data)
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    destinationPath = documentsPath + (urlString?.stringByRemovingAll(stringsToRemove))!+".png"
                    try? UIImageJPEGRepresentation(image!,1.0)!.write(to: URL(fileURLWithPath: destinationPath), options: [.atomic])
                    result(destinationPath)
                });
            }
        }
    }
    
    func downloadAudio(_ url: AudioWebURL, result:@escaping (_ url: AudioStorageURL?) -> ()) {
        let audioURL = URL(string: url)
        let audioAsset = AVAsset(url: audioURL!)
        
        guard audioAsset.isPlayable && audioAsset.isReadable else {
            Log.error("File at given URL cannot be read or played")
            result(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: audioURL!, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                Log.error(error.debugDescription)
                result(nil)
                return
            }
            
            let filePathAppend = "/Documents/\(url.stringByRemovingAll(stringsToRemove))"
            let filePath = NSHomeDirectory() + filePathAppend
            
            do {
                try data!.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
                result(filePathAppend)
            } catch let error as NSError {
                Log.error(error.debugDescription)
            }
            
        }) 
        task.resume()
    }
}
