//
//  XMLParser.swift
//  RocketCast
//
//  Created by Odin on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

class XMLParser: NSObject {
    
    var parser = NSXMLParser()
    var element = NSString()
    
    var listOfEpisodes = [EpisodeModel]()
    
    var episodeTitle = NSMutableString()
    var episodeDescription = NSMutableString()
    var episodeAuthor = NSMutableString()
    var episodePublishedDate = NSMutableString()
    var episodeDuration = NSMutableString()
    var episodeImageURL = NSMutableString()
    var episodeMP3URL = NSMutableString()
    
    var podcastTitle = NSMutableString()
    var podcastAuthor = NSMutableString()
    var podcastDescription = NSMutableString()
    var podcastImageURL = NSMutableString()
    
    var podcast:PodcastModel?
    
    
    init(data: NSData) {
        super.init()
        parseData(data)
        
    }
    
    private func parseData (data:NSData) {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        Log.test("parse is called")
        guard parser.parse() else {
            Log.error("Oh shit something went wrong")
            return
        }
        
        podcast = PodcastModel(title: podcastTitle as String,
                               author: podcastAuthor as String,
                               description: podcastDescription as String,
                               episodes: listOfEpisodes,
                               imageURL: podcastImageURL as ImageWebURL)
    }
    
}

extension XMLParser: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        if (elementName as NSString).isEqualToString("item") {
            episodeTitle = NSMutableString()
            episodePublishedDate = NSMutableString()
            episodeDescription = NSMutableString()
            episodeAuthor = NSMutableString()
            episodeDuration = NSMutableString()
            episodeImageURL = NSMutableString()
            episodeMP3URL = NSMutableString()
            
        }
        if (elementName as NSString).isEqual("itunes:image") {
            episodeImageURL.appendString(attributeDict["href"]!)
            if (podcastImageURL.isEqual("")) {
                podcastImageURL.appendString(attributeDict["href"]!)
            }
        }
        
        if(elementName as NSString).isEqual("enclosure") {
            episodeMP3URL.appendString(attributeDict["url"]!)
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let information = string.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByRemovingAll(unwantedStringInTag)
        
        switch element {
        case "title":
            episodeTitle.appendString(information)
            if (podcastTitle.isEqual("")) {
                podcastTitle.appendString(information)
            }
        case "itunes:author":
            episodeAuthor.appendString(information)
            if (podcastAuthor.isEqual("")) {
                podcastAuthor.appendString(information)
            }
        case "itunes:summary":
            if (podcastDescription.isEqual("")) {
                podcastDescription.appendString(information)
            }
        case "pubDate":
            episodePublishedDate.appendString(information)
        case "dc:creator":
            episodeAuthor.appendString(information)
        case "description":
            episodeDescription.appendString(information)
            if (podcastDescription.isEqual("")) {
                podcastDescription.appendString(information)
            }
        case "itunes:duration":
            episodeDuration.appendString(information)
        default: break
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed")
        NSLog("failure error: %@", parseError)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        fillInEpisodes(elementName)
    }
    
    func fillInEpisodes (elementName:String) {
        
        if (elementName == "item") {
            guard !episodeTitle.isEqual(nil) else {
                Log.error("Error: No title tag was detected")
                return
            }
            
            guard !episodeMP3URL.isEqual(nil) else {
                Log.error("Error: No mp3 url")
                return
            }
            
            guard !episodePublishedDate.isEqual(nil) else {
                Log.error("Error: No date tag was detected")
                return
            }
            
            guard !episodeDescription.isEqual(nil) else {
                Log.error("Error: No description tag was detected")
                return
            }
        
            if (episodeAuthor.isEqual("")) {
                episodeAuthor = podcastAuthor
            }
            if (episodeImageURL.isEqual("")) {
                episodeImageURL = podcastImageURL
            }
            
            let episode = EpisodeModel(title: episodeTitle as String,
                                       description: episodeDescription as String,
                                       date: episodePublishedDate as String,
                                       author: episodeAuthor as String,
                                       duration: episodeDuration as String,
                                       imageURL: episodeImageURL as ImageWebURL,
                                       mp3URL:  episodeMP3URL as MP3WebURL)
            
            listOfEpisodes.append(episode)
        }
    }
}