//
//  Podcast+CoreDataProperties.swift
//  RocketCast
//
//  Created by Mohamed Ali on 2016-12-02.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData
 

extension Podcast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Podcast> {
        return NSFetchRequest<Podcast>(entityName: "Podcast");
    }

    @NSManaged public var addedDate: NSDate?
    @NSManaged public var author: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var rssFeedURL: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var episodes: NSSet?

}

// MARK: Generated accessors for episodes
extension Podcast {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}
