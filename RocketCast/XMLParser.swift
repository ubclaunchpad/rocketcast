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
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
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
    
    func getPodcastAuthor() {
        
    }
    
    func getPodcastTitle() {
        
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
        if (elementName as NSString).isEqualToString("item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
            summary = ""
            summary = NSMutableString()
        }
    }

    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("title") {
            title1.appendString(string)
        } else if element.isEqualToString("pubDate") {
            date.appendString(string)
        } else if element.isEqualToString("description") {
            summary.appendString(string)
        }
    }
  
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed")
        NSLog("failure error: %@", parseError)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if (elementName as NSString).isEqualToString("item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title")
            }
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "date")
            }
            
            if !summary.isEqual(nil) {
                elements.setObject(summary, forKey: "description")
            }
            posts.addObject(elements)
        }
    }
  }