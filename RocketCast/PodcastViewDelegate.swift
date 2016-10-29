//
//  PodcastViewDelegate.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit
import CoreData
protocol PodcastViewDelegate {
    func segueToEpisode()
    func setSelectedPodcastAndSegue(selectedPodcast: Podcast)
}
