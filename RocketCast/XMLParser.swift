//
//  XMLParser.swift
//  RocketCast
//
//  Created by Odin on 2016-09-01.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

class XMLParser: NSObject {
    
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    
    
    var url: NSURL?
    var xmlContent:NSDictionary?
    init(url: NSURL) {
        super.init()
        self.url = url
        self.xmlContent = parseData()
    }
    
    func getPodcastAuthor() {
        
    }
    
    func getPodcastTitle() {
        
    }
    
    private func parseData () -> NSDictionary {
        var parser = NSXMLParser(contentsOfURL: url!)
        parser!.delegate = self
        Log.test("parse is called")
        guard parser!.parse() else {
            //TODO: error out
            return NSDictionary()
        }
        
        return NSDictionary()
    }
}

extension XMLParser: NSXMLParserDelegate {
//    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//    }
//    
//    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//    }
//    
//    func parser(parser: NSXMLParser, foundCharacters string: String) {
//    }
//    
//    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
//    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="title" || elementName=="lastBuildDate")
        {
            if(elementName=="title"){
                passName=true;
                Log.test("\(elementName)")
            }
            passData=true;
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="title" || elementName=="lastBuildDate")
        {
            if(elementName=="title"){
                passName=false;
                Log.test("\(elementName)")
            }
            passData=false;
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData=strXMLData+"\n\n"+string
        }
        
        if(passData)
        {
            Log.test(string)
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        Log.error("parsing failed")
        NSLog("failure error: %@", parseError)
    }
}