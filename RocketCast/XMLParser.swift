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
        if let data = try? Data(contentsOf: URL(string: url)!) {
            podcast = coreData.createOrUpdatePodcast(podcastUrl)
            podcast!.url = podcastUrl
            parseData(data)
        } else {
            Log.error("There's nothing in the data from url:\(url)")
        }
    }
    
    fileprivate func parseData (_ data:Data) {
        let parser = Foundation.XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else {
            Log.error("Oh shit something went wrong. OS parser failed")
            return
        }

       coreData.saveContext()
    }
 
}

extension XMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        
        if (elementName as NSString).isEqual(to: xmlKeyTags.episodeTag) {
            tmpEpisode = NSEntityDescription.insertNewObject(forEntityName: "Episode", into: coreData.managedObjectContext) as? Episode
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
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let information = string.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines).stringByRemovingAll(xmlKeyTags.unwantedStringInTag)
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = dateFormatString
                    let date = dateFormatter.date(from: information)
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        Log.error("parsing failed: " + parseError._description)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == xmlKeyTags.episodeTag) {
            if tmpEpisode!.author == nil {
                tmpEpisode!.author = podcast!.author!
            }
            tmpEpisode!.podcastUrl = podcast!.url
            
            let episodes = podcast!.episodes!.mutableCopy() as! NSMutableSet
            episodes.add(tmpEpisode!)
            podcast!.episodes = episodes.copy() as? NSSet
        }
        
    }
    
    
}


