//
//  XMLParser.swift
//  RocketCast
//
//  Created by Odin on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData

class CoreDataXMLParser: NSObject {
    
    var element = String()
    var midElement = NSMutableString()
    var podcast:Podcast?
    var samePodcast = false
    var tmpEpisode:Episode?
    
    static private var success = false
    
    init(url: String) {
        super.init()
        // in production this code will be uncommented
//        guard url == testRSSFeed || url.lowercased().contains("rss") || url.lowercased().contains("feed") else {
//            XMLParser.success = false
//            return
//        }
        
        if let data = try? Data(contentsOf: URL(string: url)!) {
            podcast = Podcast(context: DatabaseUtil.getContext())
            podcast?.rssFeedURL = url
            podcast?.addedDate = Date()
            parseData(data)
        } else {
            Log.error("There's nothing in the data from url:\(url)")
            CoreDataXMLParser.success = false
        }
    }
    
    private func parseData (_ data:Data) {
        let parser = Foundation.XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else {
            Log.error("Oh shit something went wrong. OS parser failed")
            CoreDataXMLParser.success = false
            return
        }
        guard (podcast?.title != nil && !(podcast?.title?.isEmpty)!) else {
            DatabaseUtil.getContext().delete(podcast!)
            CoreDataXMLParser.success = false
            return
        }
        
        guard (podcast?.description != nil && !(podcast?.description.isEmpty)!) else {
            DatabaseUtil.getContext().delete(podcast!)
            CoreDataXMLParser.success = false
            return
        }
        
        if (!samePodcast) {
            DatabaseUtil.saveContext()
            CoreDataXMLParser.success = true
        } else {
            DatabaseUtil.getContext().delete(podcast!)
            CoreDataXMLParser.success = false
        }
    }
    
    static func didItSucceed () -> Bool {
        return success
    }

}
extension CoreDataXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        
        if (elementName as NSString).isEqual(to: xmlKeyTags.episodeTag) {
            tmpEpisode = Episode(context: DatabaseUtil.getContext())
            tmpEpisode?.summary = ""
            midElement = NSMutableString()
            midElement = ""
        }
        
        if (elementName as NSString).isEqual(xmlKeyTags.podcastImage) {
            if (podcast!.imageURL == nil) {
                podcast!.imageURL = attributeDict[xmlKeyTags.imageLink]!
            } else  {
                tmpEpisode!.imageURL = attributeDict[xmlKeyTags.imageLink]!
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
            midElement.append(information)
            let midElementAsString = midElement.description
            switch element {
            case xmlKeyTags.title:
                if podcast!.title != nil {
                    if tmpEpisode != nil {
                        tmpEpisode!.title = midElementAsString
                    }
                } else  {
                    if (DatabaseUtil.doesThisPodcastAlreadyExist(podcastTitle: information)) {
                        samePodcast = true
                    }
                    podcast!.title = midElementAsString
                }
            case xmlKeyTags.author:
                if podcast!.author == nil {
                    podcast!.author = midElementAsString
                } else {
                    tmpEpisode!.author = midElementAsString
                }
            case xmlKeyTags.description:
                if podcast!.summary == nil {
                    podcast!.summary = midElementAsString
                }
            case xmlKeyTags.publishedDate:
                if tmpEpisode != nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = dateFormatString
                    let date = dateFormatter.date(from: midElementAsString)
                    tmpEpisode!.date = date
                }
            case xmlKeyTags.authorEpisodeTagTwo:
                if tmpEpisode != nil {
                    tmpEpisode!.author = midElementAsString
                }
            case xmlKeyTags.descriptionTagTwo:
                if podcast!.summary == nil {
                    podcast!.summary = midElementAsString
                }else {
                    if tmpEpisode != nil {
                        tmpEpisode!.summary = midElementAsString
                    }
                }
            case xmlKeyTags.duration:
                tmpEpisode!.duration = midElementAsString
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        Log.error("parsing failed: " + parseError.localizedDescription)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == xmlKeyTags.episodeTag) {
            if tmpEpisode!.author == nil {
                tmpEpisode!.author = podcast!.author!
            }
            if tmpEpisode!.imageURL == nil {
                tmpEpisode!.imageURL = podcast!.imageURL
            }
            tmpEpisode!.podcastTitle = podcast!.title
            
            let episodes = podcast!.episodes!.mutableCopy() as! NSMutableSet
            episodes.add(tmpEpisode!)
            podcast!.episodes = episodes.copy() as? NSSet
        }
        midElement = ""
    }
}


