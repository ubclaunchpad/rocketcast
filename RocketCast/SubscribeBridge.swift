
//
//  PodcastInterface.swift
//  RocketCast
//
//  Created by James Park on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit



protocol SubscribeBridgeProtocol {
    
    func startSubscription(model:PodcastModel)
    func stopSubscription(model:PodcastModel)

}
extension ModelBridge: SubscribeBridgeProtocol {

    func startSubscription(var model:PodcastModel) {
        func startCheckingForEpisodes(timer:NSTimer) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                var done = false
                var podcast = PodcastModel()
                self.downloadPodcastXML(model.podcastURL!) { (downloadedPodcast) in
                    done = true
                    //podcast = downloadedPodcast
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("update episodes")
                })
            })
        }
        var timer = NSTimer(timeInterval: 100.0, target: self, selector: "startCheckingForEpisodes:", userInfo: nil, repeats: true)
        model.timer = timer
    }

    func stopSubscription(var model:PodcastModel) {
        if((model.timer) != nil){
            model.timer!.invalidate()
        }
    }
    

}