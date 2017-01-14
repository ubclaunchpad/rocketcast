//
//  OPMLXMLParser.swift
//  RocketCast
//
//  Created by James Park on 2016-12-03.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import CoreData

class OPMLXMLParser: NSObject {

    static private var success = true
    
    init(url: String) {
        super.init()
        if let data = try? Data(contentsOf: URL(string: url)!) {
            parseData(data)
        } else {
            Log.error("There's nothing in the data from url:\(url)")
            OPMLXMLParser.success = false
        }
    }
    
    private func parseData (_ data:Data) {
        let parser = Foundation.XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else {
            Log.error("Oh shit something went wrong. OS parser in OPML failed")
            OPMLXMLParser.success = false
            return
        }
    
    }
    
    static func didItSucceed () -> Bool {
        return success
    }
    
}
extension OPMLXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        if("outline".isEqual((elementName as NSString))) {
            if let url = attributeDict["xmlUrl"] {
                Log.info(url)
                let reentrantAvoidanceQueue = DispatchQueue(label: "reentrantAvoidanceQueue")
                reentrantAvoidanceQueue.async(execute: {() -> Void in
                   _ = RssXMLParser(url: url)
                })
                reentrantAvoidanceQueue.sync(execute: {() -> Void in
                })
            }
        }
    }
}
