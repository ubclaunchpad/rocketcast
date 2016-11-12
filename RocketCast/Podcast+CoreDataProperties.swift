//
//  Podcast+CoreDataProperties.swift
//  RocketCast
//
//  Created by James Park on 2016-09-21.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Podcast {

    @nonobjc public class func fetchRequest () -> NSFetchRequest<Podcast> {
        return NSFetchRequest<Podcast>(entityName: "Podcast")
    }
    @NSManaged var title: String?
    @NSManaged var author: String?
    @NSManaged var summary: String?
    @NSManaged var imageURL: String?
    @NSManaged var episodes: NSSet?
    @NSManaged var addedDate: Date?
    @NSManaged var rssFeedURL: String?

}

extension Podcast {
    
    @objc(addEpisodeObject:)
    @NSManaged public func addToEpisode(_ value: Episode)
    
    @objc(removeEpisodeObject:)
    @NSManaged public func removeFromEpisode(_ value: Episode)
    
    
    @objc(addEpisode:)
    @NSManaged public func addToEpisode(_values: NSSet)
    
    
    @objc(removeEpisode:)
    @NSManaged public func removeFromEpisode(_values: NSSet)
    
}
