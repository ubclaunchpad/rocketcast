//
//  CoreDataHelper.swift
//  RocketCast
//
//  Created by James Park on 2016-09-21.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//  Credit to Andi Setiyadi (Senior Web and Mobile Developer)

import Foundation
import CoreData

class CoreDataHelper {
    let model = "RocketCast"
    
    /*
     A private property, it holds the location where the Core Data will store the data.
     It will use the application document directory as the location which is the recommended place to store the data.
     */
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        return urls[urls.count-1]
    }()
    
    /*
     A private property, represents object in the data model, including information on the model's property and its relationship.
     This is the reason we need to pass in our data model name in this property. As in this case,
     we name the xcdatamodeld file as "RocketCast.xcdatamodeld" and that's why we pass in the same exact name to managedObjectModel.
     */
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.model, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    /*
     A private property, this coordinator is what makes things work for Core Data.
     It orchestrated the connection between the managed object model and the persistent store.
     It is responsible in doing the heavy lifting of handling Core Data implementation.
     */
    fileprivate lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.model)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        }
        catch {
            Log.error("Error adding persistence store")
        }
        
        return coordinator
    }()
    
    /*
     A public property, this is our only accessible property from the Core Data stack.
     It has to connect to a persistenceStoreCoordinator so we can work with the managedObject in our data store.
     It also manages the lifecycle of our objects.
     */
    lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistenceStoreCoordinator
        return context
    }()
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                Log.info("Saved a new managed object")
            }
            catch let error as NSError {
                Log.error("Error saving context: " + error.localizedDescription)
            }
        }
    }
    
    func deleteAllManagedObjects () {
        let episodeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Episode)
        let podcastRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Podcast)
        
        do {
            let episodeResults = try self.managedObjectContext.fetch(episodeRequest) as! [Episode]
            
            let podcastResults = try self.managedObjectContext.fetch(podcastRequest) as! [Podcast]
            
            for episode in episodeResults {
                self.managedObjectContext.delete(episode)
            }
            
            for podcast in podcastResults {
                self.managedObjectContext.delete(podcast)
            }
            
            try self.managedObjectContext.save()
            
        } catch let error as NSError {
            Log.error("Error deleting objects: " + error.localizedDescription)
        }
    }

    func createOrUpdatePodcast (_ podcastUrl: String) -> Podcast? {
        var podcast:Podcast?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Podcast)
        if (podcastUrl != "") {
            request.predicate = NSPredicate(format:"url = %@", podcastUrl)
        }
        
        
        var wasError:Bool = false
        do {
            if let podcasts = try self.managedObjectContext.fetch(request) as? [Podcast] {
                podcast = podcasts.first
            }
        }
        catch let _ as NSError {
            wasError = true
        }
    
        if(podcast == nil || wasError){
            podcast = NSEntityDescription.insertNewObject(forEntityName: "Podcast",
                                                                          into: self.managedObjectContext) as? Podcast
        }
        
        return podcast

    }
    
    func deletePodcast (_ podcastUrl: PodcastWebURL) {
        let podcastRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Podcast)
        podcastRequest.predicate = NSPredicate(format:"url = %@", podcastUrl)
        let episodeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Episode)
        episodeRequest.predicate = NSPredicate(format:"podcastUrl = %@", podcastUrl)
        
        do {
            let podcastResults = try self.managedObjectContext.fetch(podcastRequest) as! [Podcast]
            for podcast in podcastResults {
                self.managedObjectContext.delete(podcast)
            }
            
            let episodeResults = try self.managedObjectContext.fetch(episodeRequest) as! [Episode]
            for episode in episodeResults {
                self.managedObjectContext.delete(episode)
            }
            
            try self.managedObjectContext.save()
            Log.info("Deleted the podtcast")
            
        } catch let error as NSError {
            Log.error("Failed deleting podcast: " + error.localizedDescription);
        }
    }
    
    func getPodcast (_ podcastUrl: PodcastWebURL?) -> Podcast? {
        var podcast:Podcast?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Podcast)
        if (podcastUrl != "") {
            request.predicate = NSPredicate(format:"url = %@", podcastUrl!)
        }
        
        do {
            if let podcasts = try self.managedObjectContext.fetch(request) as? [Podcast] {
                podcast = podcasts.first

            }
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
