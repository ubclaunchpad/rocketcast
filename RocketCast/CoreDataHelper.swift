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
class CoreDataHelper {
    lazy var persistentContainer: NSPersistentContainer = {
 
        let container = NSPersistentContainer(name: "RocketCast")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                               fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
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
    
    func deleteAllManagedObjects () {
        
        let moc = self.persistentContainer.viewContext
        let episodeRequest:NSFetchRequest<Episode> = Episode.fetchRequest()
        let podcastRequest:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        var deleteRequest: NSBatchDeleteRequest
        var deleteResults: NSPersistentStoreResult
        
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: podcastRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try moc.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: episodeRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try moc.execute(deleteRequest)


            
        } catch let error as NSError {
            Log.error("Error deleting objects: " + error.localizedDescription)
        }
    }
    
    
    func deletePodcast (_ podcastTitle: String) {
        let moc = self.persistentContainer.viewContext
        let podcastRequest:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        podcastRequest.predicate = NSPredicate(format:"title = %@", podcastTitle as CVarArg)
        let episodeRequest:NSFetchRequest<Episode> = Episode.fetchRequest()
        episodeRequest.predicate = NSPredicate(format:"podcastTitle = %@", podcastTitle as CVarArg)
        
        do {
            let podcastResults = try moc.fetch(podcastRequest)
            for podcast in podcastResults {
                moc.delete(podcast)
            }
            
            let episodeResults = try moc.fetch(episodeRequest)
            for episode in episodeResults {
                moc.delete(episode)
            }
            
            Log.info("Deleted the podtcast")
            
        } catch let error as NSError {
            Log.error("Failed deleting podcast: " + error.localizedDescription);
        }
    }
    
    func getPodcast (_ podcastTitle: String?) -> Podcast? {
        var podcast:Podcast?
        let moc = self.persistentContainer.viewContext
        let request:NSFetchRequest<Podcast> = Podcast.fetchRequest()
        if (podcastTitle != nil) {
            request.predicate = NSPredicate(format:"title = %@", podcastTitle as! CVarArg)
        }
        
        do {
            let podcasts = try moc.fetch(request)
            podcast = podcasts.first
            
        }
        catch let error as NSError {
            Log.error("Error in getting podcasts: " + error.localizedDescription)
        }
        
        return podcast
    }
    
    
    func getPodcastCount () -> NSInteger {
        let moc = self.persistentContainer.viewContext
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
