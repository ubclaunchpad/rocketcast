//
//  UrlVCTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//
import UIKit
import XCTest
@testable import RocketCast
import CoreData
class UrlVCTest: XCTestCase {
    
    var urlVC: AddUrlController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
        urlVC = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier.urlVC) as! AddUrlController
        let _ = urlVC.view
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddTheSamePodcast() {
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
        
        XCTAssertEqual(1, DatabaseUtil.getAllPodcasts().count)
        
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
        XCTAssertEqual(1, DatabaseUtil.getAllPodcasts().count)
        
    }
    
       
}
