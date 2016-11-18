//
//  ItuneWebDelegate.swift
//  RocketCast
//
//  Created by James Park on 2016-11-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

protocol ItuneWebDelegate {
    func getPodcastsFromItuneAPI(_inputString:String) // swiftlint:disable:this force_cast
    func savePodcastToCoreDataFromItuneAPI(_rssFeed: String) // swiftlint:disable:this force_cast
    func segueToAddUrl()
}
