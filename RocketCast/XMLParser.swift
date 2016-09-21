//
//  XMLParser.swift
//  RocketCast
//
//  Created by Odin on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

class XMLParser: NSObject {
    
    var element = String()
    
    var podcast = PodcastModel()

    init(url: String) {
        super.init()
        if let data = NSData(contentsOfURL:NSURL(string: url)!) {
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
        
    }
    
    func getGeneratedPodcast () -> PodcastModel {
        return podcast
    }
    
}

extension XMLParser: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        
        if (elementName as NSString).isEqualToString(xmlKeyTags.episodeTag) {
            podcast.episodes?.append(EpisodeModel())
        }
        if (elementName as NSString).isEqual(xmlKeyTags.podcastImage) {
            
            if (podcast.imageURL!.isEmpty) {
                podcast.imageURL = attributeDict[xmlKeyTags.imageLink]!
            } else if var tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.imageURL = attributeDict[xmlKeyTags.imageLink]!
                podcast.episodes?.append(tempEpisode)
            }
        }
        
        if(elementName as NSString).isEqual(xmlKeyTags.startTagMP3URL) {
            if var tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.mp3URL = attributeDict[xmlKeyTags.mp3URL]!
                podcast.episodes?.append(tempEpisode)
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let information = string.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByRemovingAll(xmlKeyTags.unwantedStringInTag)
    
        switch element {
        case xmlKeyTags.title:
            if ((podcast.title!.isEqual(""))) {
                podcast.title!.appendString(information)
            } else if let tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.title!.appendString(information)
                podcast.episodes?.append(tempEpisode)
            }
        case xmlKeyTags.author:
            if (podcast.author!.isEqual("")) {
                podcast.author!.appendString(information)
            } else if let tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.author!.appendString(information)
                self.podcast.episodes?.append(tempEpisode)
            }
        case xmlKeyTags.description:
            if (podcast.description!.isEqual("")) {
                podcast.description!.appendString(information)
            }
        case xmlKeyTags.publishedDate:
            if  let tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.date!.appendString(information)
                podcast.episodes?.append(tempEpisode)
            }
        case xmlKeyTags.authorEpisodeTagTwo:
            if let  tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.author!.appendString(information)
                podcast.episodes?.append(tempEpisode)
            }
        case xmlKeyTags.descriptionTagTwo:
            if (podcast.description!.isEqual("")) {
                podcast.description!.appendString(information)
            }else if  let  tempEpisode = podcast.episodes?.popLast() {
                tempEpisode.description!.appendString(information)
                podcast.episodes?.append(tempEpisode)
            }
        case xmlKeyTags.duration:
            if let tempEpisode = podcast.episodes?.popLast(){
                tempEpisode.duration!.appendString(information)
                podcast.episodes?.append(tempEpisode)
            }
        default: break
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed: " + parseError.description)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == xmlKeyTags.episodeTag) {
            if var tempEpisode = podcast.episodes?.popLast() {
                if tempEpisode.author!.isEqual("") {
                    tempEpisode.author = podcast.author!
                }
                podcast.episodes?.append(tempEpisode)
            }
        }
        
    }
    
    
}


