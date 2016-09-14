//
//  XMLParser.swift
//  RocketCast
//
//  Created by Odin on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

class XMLParser: NSObject {
    
    var element = NSString()
    
    var podcast = PodcastModel()

    init(url: String) {
        super.init()
        if let data = NSData(contentsOfURL:NSURL(string: url)!) {
            parseData(data)
        } else {
            Log.error("There's nothing in the data")
        }
        
    }
    
    private func parseData (data:NSData) {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else {
            Log.error("Oh shit something went wrong")
            return
        }
        
    }
    
    func getGeneratedPodcast () -> PodcastModel {
        return podcast
    }
    
}

extension XMLParser: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        
        if (elementName as NSString).isEqualToString("item") {
            podcast.episodes.append(EpisodeModel())
        }
        if (elementName as NSString).isEqual("itunes:image") {
            
            if (podcast.imageURL.isEmpty) {
                podcast.imageURL = attributeDict["href"]!
            } else if var tempEpisode = podcast.episodes.popLast() {
                tempEpisode.imageURL = attributeDict["href"]!
                podcast.episodes.append(tempEpisode)
            }
        }
        
        if(elementName as NSString).isEqual("enclosure") {
            if var tempEpisode = podcast.episodes.popLast() {
                tempEpisode.mp3URL = attributeDict["url"]!
                podcast.episodes.append(tempEpisode)
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let information = string.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByRemovingAll(unwantedStringInTag)
        
        switch element {
        case "title":
            if ((podcast.title.isEqual(""))) {
                podcast.title.appendString(information)
            } else if let tempEpisode = podcast.episodes.popLast() {
                tempEpisode.title.appendString(information)
                podcast.episodes.append(tempEpisode)
            }
        case "itunes:author":
            if (podcast.author.isEqual("")) {
                podcast.author.appendString(information)
            } else if let tempEpisode = podcast.episodes.popLast() {
                tempEpisode.author.appendString(information)
                self.podcast.episodes.append(tempEpisode)
            }
        case "itunes:summary":
            if (podcast.description.isEqual("")) {
                podcast.description.appendString(information)
            }
        case "pubDate":
            if  let tempEpisode = podcast.episodes.popLast() {
                tempEpisode.date.appendString(information)
                podcast.episodes.append(tempEpisode)
            }
        case "dc:creator":
            if let  tempEpisode = podcast.episodes.popLast() {
                tempEpisode.author.appendString(information)
                podcast.episodes.append(tempEpisode)
            }
        case "description":
            if (podcast.description.isEqual("")) {
                podcast.description.appendString(information)
            }else if  let  tempEpisode = podcast.episodes.popLast() {
                tempEpisode.description.appendString(information)
                podcast.episodes.append(tempEpisode)
            }
        case "itunes:duration":
            if let tempEpisode = podcast.episodes.popLast(){
                tempEpisode.duration.appendString(information)
                podcast.episodes.append(tempEpisode)
            }
        default: break
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed: " + parseError.description)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            if var tempEpisode = podcast.episodes.popLast() {
                if tempEpisode.author.isEqual("") {
                    tempEpisode.author = podcast.author
                }
                podcast.episodes.append(tempEpisode)
            }
        }
        
    }
    
    
}


