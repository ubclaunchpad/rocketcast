//
//  CoreDataHelper.swift
//  RocketCast
//
//  Created by James Park on 2016-09-21.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//  Credit to Andi Setiyadi (Senior Web and Mobile Developer)

import Foundation
import CoreData

@available(iOS 10.0, *)
class DatabaseController {
    
    private init() {
        
    }
    class func getContext() -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
 
        let container = NSPersistentContainer(name: "RocketCast")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                               fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                            }
        }
    }
    
    // MARK: - Delete Everything in CoreData
    static func deleteAllManagedObjects () {
    
        let episodeRequest:NSFetchRequest<Episode> = Episode.fetchRequest()
        let podcastRequest:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        var deleteRequest: NSBatchDeleteRequest
        
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: podcastRequest as! NSFetchRequest<NSFetchRequestResult>)
             try DatabaseController.getContext().execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: episodeRequest as! NSFetchRequest<NSFetchRequestResult>)
            try DatabaseController.getContext().execute(deleteRequest)
        } catch let error as NSError {
            Log.error("Error deleting objects: " + error.localizedDescription)
        }
    }
    
    
    // MARK: - Core Data Podcast functionailty
    
    static func getPodcast (byTitle: String)  -> Podcast {
        let podcastRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        var podcast:Podcast?
        podcastRequest.predicate = NSPredicate(format:"title = %@", (byTitle as? CVarArg)!)
        
        do {
            let podcasts = try DatabaseController.getContext().fetch(podcastRequest)
            podcast = podcasts.first
            
        }
        catch let error as NSError {
            Log.error("Error in getting podcasts: " + error.localizedDescription)
        }
        
        return podcast!
        
    }
    
    
    
    static func getAllPodcasts() -> [Podcast] {
        let podcastRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        do {
            let podcasts = try DatabaseController.getContext().fetch(podcastRequest)
            return podcasts
        }
        catch {
            fatalError("Error in getting podcasts")
        }
    }
    
    static func getPodcastCount () -> NSInteger {
        let request:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        do {
            let count = try DatabaseController.getContext().count(for: request)
            return count
            
        } catch let error as NSError {
            Log.error("Error in getting count from podcasts: " + error.localizedDescription)
        }
        
        return -1
    }
    
    static func deletePodcast (_ podcastTitle: String) {
        let podcastRequest:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        podcastRequest.predicate = NSPredicate(format:"title = %@", podcastTitle as CVarArg)
        let episodeRequest:NSFetchRequest<Episode> = Episode.fetchRequest()
        episodeRequest.predicate = NSPredicate(format:"podcastTitle = %@", podcastTitle as CVarArg)
        
        do {
            let podcastResults = try DatabaseController.getContext().fetch(podcastRequest)
            DatabaseController.getContext().delete(podcastResults.first!)
            
            
            let episodeResults = try  DatabaseController.getContext().fetch(episodeRequest)
            for episode in episodeResults {
                DatabaseController.getContext().delete(episode)
            }
            
            Log.info("Deleted the podtcast")
            
        } catch let error as NSError {
            Log.error("Failed deleting podcast: " + error.localizedDescription);
        }
    }
    
    
     // MARK: - Core Data Episode functionailty
    static func getEpisode (_ episodeTitle: String?) -> Episode? {
        var episode:Episode?
        let request:NSFetchRequest<Episode> = Episode.fetchRequest()
        if (episodeTitle != nil) {
            request.predicate = NSPredicate(format:"title = %@", episodeTitle as! CVarArg)
        }
        
        do {
            let episodes = try DatabaseController.getContext().fetch(request)
            episode = episodes.first
            
        }
        catch let error as NSError {
            Log.error("Error in getting podcasts: " + error.localizedDescription)
        }
        
        return episode
    }

    

}
