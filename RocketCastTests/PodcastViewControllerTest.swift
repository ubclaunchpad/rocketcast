//
//  PodcastViewControllerTest.swift
//  RocketCast
//
//  Created by James Park on 2016-12-04.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import XCTest
@testable import RocketCast
class PodcastViewControllerTest: XCTestCase {
    
    var urlVC:AddUrlController!
    override func setUp() {
        super.setUp()
        DatabaseUtil.deleteAllManagedObjects()
        urlVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.urlVC) as! AddUrlController
        urlVC.viewDidLoad()
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseUtil.deleteAllManagedObjects()
        super.tearDown()
    }
    
    func testAddPodcastViaURL() {
        
        let podcastVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewControllerIdentifier.podcastVC) as! PodcastController
        
        podcastVC.viewDidLoad()
       // podcastVC.mainView?.podcastsToView = DatabaseUtil.getAllPodcasts()
        
        let podcastCollectionView = podcastVC.mainView?.podcastView
        XCTAssertEqual(2, podcastCollectionView?.numberOfSections)
        XCTAssertEqual(1, podcastCollectionView?.numberOfItems(inSection: 1))
        
        // Section 1 is the title of the collection view
        
        let titleCollectionView = podcastVC.mainView?.collectionView(podcastCollectionView!, cellForItemAt:  IndexPath(item: 0, section: 0)) as! PodcastsTitleCollectionViewCell
        XCTAssertEqual("Podcasts", titleCollectionView.titleLabel.text)
        
        // Section 2 shows you the podcasts
        
        let firstPodcastCollectionView =  podcastVC.mainView?.collectionView(podcastCollectionView!, cellForItemAt: IndexPath(item: 0, section: 1)) as! PodcastViewCollectionViewCell
    
        XCTAssertEqual(SamplePodcast.podcastTitle, firstPodcastCollectionView.podcastTitle.text)
        XCTAssertEqual(SamplePodcast.author, firstPodcastCollectionView.podcastAuthor.text)
    }
}
