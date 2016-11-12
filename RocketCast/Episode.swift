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

// Insert code here to add functionality to your managed object subclass
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d"
        if let episodeDate = self.date  {
            return dateFormatter.string(from: episodeDate)
        }
        return dateFormatter.string(from: Date())
    }
    
    func getDuration() -> String {
        guard let  timeArray = self.duration?.components(separatedBy: ":") else {
            return ""
        }
        guard let digitOne = Int((timeArray[0])) else {
            return ""
        }
        if timeArray.count == 2 {
            return "\(timeArray[0]) \(PodcastInfoStrings.minute)"
        } else if timeArray.count == 3 {
            guard let digitTwo = Int((timeArray[1])) else {
                return ""
            }
            return "\(digitOne) \(digitOne > 1 ? PodcastInfoStrings.pluralHour : PodcastInfoStrings.singularHour) \(digitTwo) \(PodcastInfoStrings.minute)"
        }
        return ""
    }
}
