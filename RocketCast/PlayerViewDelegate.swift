//
//  PlayerViewDelegate.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

protocol PlayerViewDelegate {
    func playPodcast()
    func pausePodcast()
    func goForward()
    func goBack()
    func stopPodcast()
    func setUpPlayer(webUrl:String)
    
    func openDeleteModal()
    func closeDeleteModal()
    
    func changeSpeed() -> String
    
    func updateProgressView()
    func playNextEpisode()
}

