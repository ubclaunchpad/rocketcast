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

    @NSManaged var title: String?
    @NSManaged var author: String?
    @NSManaged var summary: String?
    @NSManaged var imageURL: String?
    @NSManaged var episodes: NSSet?

}
