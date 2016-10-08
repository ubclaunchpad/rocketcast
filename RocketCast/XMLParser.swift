//
//  XMLParser.swift
//  RocketCast
//
//  Created by Odin on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData

class XMLParser: NSObject {
    
    var element = String()
    let coreData = CoreDataHelper()
    var podcast:Podcast?
    var tmpEpisode:Episode?
    
    
    init(url: String, podcastUrl: PodcastWebURL) {
        super.init()
        if let data = NSData(contentsOfURL:NSURL(string: url)!) {
            podcast = coreData.createOrUpdatePodcast(podcastUrl)
            podcast!.url = podcastUrl
            parseData(data)
        } else {
            Log.error("There's nothing in the data from url:\(url)")
        }
    }
    
    private func parseData (data:NSData) {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else {
            Log.error("Oh shit something went wrong. OS parser failed")
            return
        }

       coreData.saveContext()
    }
 
}

extension XMLParser: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        
        if (elementName as NSString).isEqualToString(xmlKeyTags.episodeTag) {
            tmpEpisode = NSEntityDescription.insertNewObjectForEntityForName("Episode", inManagedObjectContext: coreData.managedObjectContext) as? Episode
        }
        
        if (elementName as NSString).isEqual(xmlKeyTags.podcastImage) {
            if (podcast!.imageURL == nil) {
                podcast!.imageURL = attributeDict[xmlKeyTags.imageLink]!
            } else  {
                if(tmpEpisode != nil){
                    tmpEpisode!.imageURL = attributeDict[xmlKeyTags.imageLink]!
                }
            }
        }
        
        if(elementName as NSString).isEqual(xmlKeyTags.startTagAudioURL) {
            tmpEpisode!.audioURL = attributeDict[xmlKeyTags.audioURL]!
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let information = string.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByRemovingAll(xmlKeyTags.unwantedStringInTag)
        if (!information.isEmpty){
            switch element {
            case xmlKeyTags.title:
                if podcast!.title != nil {
                    if tmpEpisode != nil {
                        tmpEpisode!.title = information
                    }
                } else  {
                    podcast!.title = information
                }
            case xmlKeyTags.author:
                if podcast!.author == nil {
                    podcast!.author = information
                } else if tmpEpisode != nil {
                    tmpEpisode!.author = information
                }
            case xmlKeyTags.description:
                if podcast!.summary == nil {
                    podcast!.summary = information
                }
            case xmlKeyTags.publishedDate:
                if tmpEpisode != nil {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = dateFormatString
                    let date = dateFormatter.dateFromString(information)
                    tmpEpisode!.date = date
                }
            case xmlKeyTags.authorEpisodeTagTwo:
                if tmpEpisode != nil {
                    tmpEpisode!.author = information
                }
            case xmlKeyTags.descriptionTagTwo:
                if podcast!.summary == nil {
                    podcast!.summary = information
                }else {
                    if tmpEpisode != nil {
                        tmpEpisode!.summary = information
                    }
                }
            case xmlKeyTags.duration:
                
                tmpEpisode!.duration = information

            default: break
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed: " + parseError.description)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == xmlKeyTags.episodeTag) {
            if tmpEpisode!.author == nil {
                tmpEpisode!.author = podcast!.author!
            }
            tmpEpisode!.podcastUrl = podcast!.url
            
            let episodes = podcast!.episodes!.mutableCopy() as! NSMutableSet
            episodes.addObject(tmpEpisode!)
            podcast!.episodes = episodes.copy() as? NSSet
        }
        
    }
    
    
}


