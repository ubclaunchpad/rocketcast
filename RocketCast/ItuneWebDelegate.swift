//
//  ItuneWebDelegate.swift
//  RocketCast
//
//  Created by James Park on 2016-11-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

protocol ItuneWebDelegate {
    func getPodcastsFromItuneAPI(_inputString:String)
    func savePodcastToCoreDataFromItuneAPI(_rssFeed: String)
    func segueToAddUrl()
}
