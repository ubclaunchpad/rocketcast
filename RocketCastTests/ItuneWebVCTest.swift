//
//  ItuneWebVCTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-05.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import XCTest
@testable import RocketCast
class ItuneWebVCTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testItuneAPI() {
        let ituneVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.ituneVC) as! ItuneWebController

        // Mock the information 
        
        var mockPodcastFromAPI = PodcastFromAPI()
        mockPodcastFromAPI.author = "testAuthor"
        mockPodcastFromAPI.podcastTitle = SamplePodcast.podcastTitle
        mockPodcastFromAPI.rssFeed = "https://s3-us-west-2.amazonaws.com/podcastassets/Episodes/testPodcastMadeup.xml"
        mockPodcastFromAPI.imageUrl = "http://www.josepvinaixa.com/blog/wp-content/uploads/2015/10/ADELE-Hello-2015-1400x1400.jpg"
        ituneVC.viewDidLoad()
        let searchBar = ituneVC.mainView?.searchBar
        ituneVC.mainView?.searchBar(searchBar!, textDidChange: "Monday Morning")
        ituneVC.mainView?.discoveredPodcasts = [mockPodcastFromAPI]
        
        
        let podcastTable = ituneVC.mainView?.podcastTable
        let cell =  ituneVC.mainView?.tableView(podcastTable!, cellForRowAt: IndexPath(item: 0, section: 0)) as! ItuneWebTableViewCell
        
        
        XCTAssertEqual(SamplePodcast.podcastTitle, cell.podcastTitle.text)
        
        
        ituneVC.mainView?.tableView(podcastTable!, didSelectRowAt: IndexPath(item: 0, section: 1))
    
    }
}
