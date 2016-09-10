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

    var element = NSString()
    var author = NSMutableString()
    var summary = NSMutableString()
    var date = NSMutableString()
    var podcast:PodcastModel?
    
    var url: NSURL?
    var xmlContent:NSDictionary?
    init(url: NSURL) {
        super.init()
        self.url = url
        parseData()
    }
    
    private func parseData () {
        let parser = NSXMLParser(contentsOfURL: url!)
        parser!.delegate = self
        Log.test("parse is called")
        guard parser!.parse() else {
            Log.error("Oh shit something went wrong")
            return
        }
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
        } else if element.isEqualToString("pubDate") {
            date.appendString(string)
        } else if element.isEqualToString("description") {
            summary.appendString(string)
        } else if element.isEqualToString("itunes:author") {
            author.appendString(string)
        }
    }
  
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed")
        NSLog("failure error: %@", parseError)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        guard elementName == "channel" else {
            Log.error ("Error: No channel tag was detected")
            return
        }
        
        guard !episodeTitle.isEqual(nil) else {
            Log.error("Error: No title tag was detected")
            return
        }
        
        
        fillInEpisodes(elementName)
    }
    
    func fillInEpisodes (elementName:String) {
        guard elementName == "item" else {
            Log.error("Error: No item tag was detected")
            return
        }
    
        guard !episodeTitle.isEqual(nil) else {
            Log.error("Error: No title tag was detected")
            return
        }
        
        guard !date.isEqual(nil) else {
            Log.error("Error: No date tag was detected ")
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