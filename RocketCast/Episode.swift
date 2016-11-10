//
//  Episode.swift
//  RocketCast
//
//  Created by James Park on 2016-09-21.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData


class Episode: NSManagedObject {

    static var isDownloading = false
// Insert code here to add functionality to your managed object subclass
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self.date!)
    }
    
    func getDuration() -> String {
        var timeArray = self.duration?.components(separatedBy: ":")
        let digitOne = Int((timeArray?[0])!)!
        let digitTwo = Int((timeArray?[1])!)!
        if timeArray?.count == 2 {
            return "\(timeArray![0]) \(PodcastInfoStrings.minute)"
        } else if timeArray?.count == 3 {
            return "\(digitOne) \(digitOne > 1 ? PodcastInfoStrings.pluralHour : PodcastInfoStrings.singularHour) \(digitTwo) \(PodcastInfoStrings.minute)"
        }
        return ""
    }
}
