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
    func stopPodcast()
    func setUpPlayer()
    
    func getEpisodeTitle() -> String
    func getEpisodeDesc() -> String
    
    func changeSpeed(_ rateTag: Int)
    func getEpisodeImage(_ result: (_ image: UIImage) -> ())
}

