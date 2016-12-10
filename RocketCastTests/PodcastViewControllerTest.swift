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
import CoreData
class PodcastViewControllerTest: XCTestCase {
    
    
    var podcastVC: PodcastController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
               let urlVC = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier.urlVC) as! AddUrlController

        let _ = urlVC.view
        urlVC.mainView?.addPodcastBtnPressed(UIControlEvents.touchUpInside as AnyObject)
        
        podcastVC = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier.podcastVC) as! PodcastController
    
        let _ = podcastVC.view

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddPodcastViaURL() {
        let podcastCollectionView = podcastVC.mainView?.podcastView
        XCTAssertEqual(2, podcastCollectionView?.numberOfSections)
        XCTAssertEqual(1, podcastCollectionView?.numberOfItems(inSection: 1))
        
        // Section 1 is the title of the collection view
        let titleCollectionView = podcastVC.mainView?.collectionView(podcastCollectionView!, cellForItemAt:  IndexPath(item: 0, section: 0)) as! PodcastsTitleCollectionViewCell
        XCTAssertEqual("Podcasts", titleCollectionView.titleLabel.text)
        
        // Section 2 shows you the podcasts
         sleep(8)
        if let firstPodcastCollectionView =  podcastVC.mainView?.collectionView(podcastCollectionView!, cellForItemAt: IndexPath(item: 0, section: 1)) as? PodcastViewCollectionViewCell {
            XCTAssertEqual(SamplePodcast.podcastTitle, firstPodcastCollectionView.podcastTitle.text)
            XCTAssertEqual(SamplePodcast.author, firstPodcastCollectionView.podcastAuthor.text)

        }
    }
    
    func testReloadPodcast () {
    
        var podcastCollectionView = podcastVC.mainView?.podcastView
        XCTAssertEqual(2, podcastCollectionView?.numberOfSections)
        XCTAssertEqual(1, podcastCollectionView?.numberOfItems(inSection: 1))

        podcastVC.mainView?.podcastView.reloadData()
        podcastVC.updateAllPodcasts()
        
        podcastCollectionView = podcastVC.mainView?.podcastView
        XCTAssertEqual(2, podcastCollectionView?.numberOfSections)
        XCTAssertEqual(1, podcastCollectionView?.numberOfItems(inSection: 1))
    
    }
    
    func testDeletePodcast () {
    
        podcastVC.toggleDeleteMode()
        let podcastCollectionView = podcastVC.mainView?.podcastView
        podcastVC.mainView?.collectionView(podcastCollectionView!, didSelectItemAt: IndexPath(item: 0, section: 1))
        podcastCollectionView?.reloadData()
        XCTAssertEqual(0, DatabaseUtil.getAllPodcasts().count)
        XCTAssertEqual(0, podcastCollectionView?.numberOfItems(inSection: 1))
        
    }

    
}
