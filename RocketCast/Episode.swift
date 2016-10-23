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
    
    func getAllEpisodes() -> [Episode] {
        let episodeRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
         let sort = NSSortDescriptor(key: "date", ascending:  false)
        episodeRequest.sortDescriptors = [sort]
        do {
            let episodes = try moc.fetch(episodeRequest)
            return episodes
        }
        catch {
            fatalError("Error in getting sold history")
        }
    }


}
