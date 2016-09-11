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
    var date = NSMutableString()
    
    var podcastTitle = NSMutableString()
    var podcastAuthor = NSMutableString()
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
                               author: podcastAuthor as String,
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
            episodeDescription = NSMutableString()
            episodeDescription = ""
            episodeAuthor = NSMutableString()
            episodeAuthor = ""
           
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        switch element {
            case "title":
                episodeTitle.appendString(string)
                if (podcastTitle.isEqual("")) {
                    podcastTitle.appendString(string)
                }
            case "itunes:author":
                episodeAuthor.appendString(string)
                if (podcastAuthor.isEqual("")) {
                    podcastAuthor.appendString(string)
                }
            case "itunes:summary":
                podcastDescription.appendString(string)
            case "pubDate":
                date.appendString(string)
            case "dc:creator":
                episodeAuthor.appendString(string)
            case "description":
                episodeDescription.appendString(string)
                if (podcastDescription.isEqual("")) {
                     podcastDescription.appendString(string)
                }
            
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
            
            guard !date.isEqual(nil) else {
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
            
            let episode = EpisodeModel(title: episodeTitle as String,
                                       description: episodeDescription as String,
                                       date: date as String,
                                       author: episodeAuthor as String)
            listOfEpisodes.append(episode)
        }
    }
}