//
//  Podcast.swift
//  RocketCast
//
//  Created by James Park on 2016-09-21.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData


class Podcast: NSManagedObject {
    
    

// Insert code here to add functionality to your managed object subclass
    func getPodcast (byTitle: String)  -> Podcast {
        let podcastRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        var podcast:Podcast?
        podcastRequest.predicate = NSPredicate(format:"title = %@", (byTitle as? CVarArg)!)
        
        do {
            let podcasts = try moc.fetch(podcastRequest)
            podcast = podcasts.first
            
        }
        catch let error as NSError {
            Log.error("Error in getting podcasts: " + error.localizedDescription)
        }
        
        return podcast!
        
    }
    
    
    func getAllPodcasts() -> [Podcast] {
        let podcastRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        do {
            let podcasts = try moc.fetch(podcastRequest)
            return podcasts
        }
        catch {
            fatalError("Error in getting sold history")
        }
    }
    
    func getPodcastCount () -> NSInteger {
             let request:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        do {
            let count = try moc.count(for: request)
            return count
            
        } catch let error as NSError {
            Log.error("Error in getting count from podcasts: " + error.localizedDescription)
        }
        
        return -1
    }
}
