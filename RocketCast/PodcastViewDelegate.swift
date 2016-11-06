//
//  PodcastViewDelegate.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit
protocol PodcastViewDelegate {
    func segueToEpisode()
    func segueToAddUrl()
    func segueToPlayer()
    func setSelectedPodcastAndSegue(selectedPodcast: Podcast)
    func updateAllPodcasts()
}
