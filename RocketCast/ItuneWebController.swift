//
//  ItuneWebController.swift
//  RocketCast
//
//  Created by James Park on 2016-11-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ItuneWebController: UIViewController {
    
    var mainView: ItuneWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = ItuneWebView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Url", style: .plain, target: self, action: #selector(segueToAddUrl))
    }
}

extension ItuneWebController:ItuneWebDelegate,ItuneWebTableViewCellDelegate {
    
    struct ItuneAPIJson {
        let key = "results"
        let podcastTitle = "collectionName"
        let podcastImage = "artworkUrl60"
        let feedUrl = "feedUrl"
        
        init () {
        }
    }
    
    func getPodcastsFromItuneAPI(_inputString:String) {
        guard !_inputString.isEmpty else {
            DispatchQueue.main.async {
                self.mainView?.discoveredPodcasts = []
                self.mainView?.podcastTable.reloadData()
            }
            
            return
        }
        // TODO remove replacingOccurrences
        guard let cleanedString = _inputString.replacingOccurrences(of: " ", with: "+").addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        
        let fetchPodcastURL = "https://itunes.apple.com/search?term=" + cleanedString + "&country=us&entity=podcast&limit=25"
        
        let apiFormat = ItuneAPIJson()
        
        Alamofire.request(fetchPodcastURL)
            .responseJSON(completionHandler: { response in
                guard response.result.error == nil else {
                    Log.error("Unable to make rest call due to \(response.result.error.debugDescription)")
                    return
                }
                
                guard let value = response.result.value else {
                    Log.error("Rest call returned invalid response.")
                    return
                }
                
                let podcastsResults = JSON(value)[apiFormat.key].arrayValue
                var podcastsAPI = [PodcastFromAPI]()
                for podcast in podcastsResults {
                    
                    if podcast["collectionName"].stringValue == podcast["artistName"].stringValue {
                        continue
                    }
                    
                    guard let podcastTitle = podcast[apiFormat.podcastTitle].string else {
                        return
                    }
                    
                    guard let podcasrUrl =  podcast[apiFormat.feedUrl].string else {
                        return
                    }
                    
                    guard let podcastImage =  podcast[apiFormat.podcastImage].string else {
                        return
                    }
                    
                    var newPodcast = PodcastFromAPI()
                    newPodcast.podcastTitle = podcastTitle
                    newPodcast.imageUrl = podcastImage
                    newPodcast.rssFeed = podcasrUrl
                    podcastsAPI.append(newPodcast)
                }
                DispatchQueue.main.async {
                    self.mainView?.discoveredPodcasts = podcastsAPI
                    self.mainView?.podcastTable.reloadData()
                }
            })
    }
    
    func savePodcastToCoreDataFromItuneAPI (_rssFeed: String) {
        CoreDataXMLParser(url: _rssFeed)
        self.performSegue(withIdentifier: Segues.segueFromItuneAPIToPodcast, sender: self)
    }
    
    func segueToAddUrl() {
        performSegue(withIdentifier: Segues.segueFromItuneWebToAddUrl, sender: self)
    }
    
}
