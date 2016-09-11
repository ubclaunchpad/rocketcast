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
    var listOfEpisodes = [EpisodeModel]()
    var episodeTitle = NSMutableString()
    
    var podcastTitle = NSMutableString()
    var element = NSString()
    var author = NSMutableString()
    var summary = NSMutableString()
    var date = NSMutableString()
    var podcastDescription = NSMutableString()
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
                               author: author as String,
                               description: podcastDescription as String,
                               episodes: listOfEpisodes)
    }
    
}

extension XMLParser: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        if (elementName as NSString).isEqualToString("item") {
            episodeTitle = NSMutableString()
            episodeTitle = ""
            date = NSMutableString()
            date = ""
            summary = ""
            summary = NSMutableString()
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("title") {
            episodeTitle.appendString(string)
            if (podcastTitle.isEqual("")) {
                podcastTitle.appendString(string)
            }
        } else if element.isEqualToString("pubDate") {
            date.appendString(string)
        } else if element.isEqualToString("description") {
            summary.appendString(string)
        } else if element.isEqualToString("itunes:author") {
            author.appendString(string)
        } else if element.isEqualToString("itunes:summary"){
            podcastDescription.appendString(string)
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed")
        NSLog("failure error: %@", parseError)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        fillInEpisodes(elementName)
    }
    
    func fillInEpisodes (elementName:String) {
        
        if (elementName == "item") {
            guard !episodeTitle.isEqual(nil) else {
                Log.error("Error: No title tag was detected")
                return
            }
            
            guard !date.isEqual(nil) else {
                Log.error("Error: No date tag was detected")
                return
            }
            
            guard !summary.isEqual(nil) else {
                Log.error("Error: No description tag was detected")
                return
            }
            
            let episode = EpisodeModel(title: episodeTitle as String,
                                       description: summary as String,
                                       date: date as String)
            listOfEpisodes.append(episode)
        }
    }
}