//
//  OPMLXMLParserTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-03.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import XCTest
@testable import RocketCast
class OPMLXMLParserTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        DatabaseUtil.deleteAllManagedObjects()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOPMLXML() {
        let xmlfilePath = Bundle.main.url(forResource: "sampleOPMLdata", withExtension: "xml")!
        let stringPath = xmlfilePath.absoluteString
        _ = OPMLXMLParser(url: stringPath)
    }
    
}
