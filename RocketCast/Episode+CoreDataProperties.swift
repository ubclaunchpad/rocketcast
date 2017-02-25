//
//  Episode+CoreDataProperties.swift
//  RocketCast
//
//  Created by Mohamed Ali on 2016-12-03.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode");
    }

    @NSManaged public var audioURL: String?
    @NSManaged public var author: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var doucmentaudioURL: String?
    @NSManaged public var duration: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var podcastTitle: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?

}
