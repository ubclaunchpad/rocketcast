//
//  ItuneWebController.swift
//  RocketCast
//
//  Created by James Park on 2016-11-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

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
    
    private func setupView() {
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
        
        guard let cleanedString = _inputString.replacingOccurrences(of: " ", with: "+").addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        
        let fetchPodcastURL =  "https://itunes.apple.com/search?term=" + cleanedString + "&country=us&entity=podcast&limit=25"
        
        let apiFormat = ItuneAPIJson()
        
        let requestURL: NSURL = NSURL(string: fetchPodcastURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            guard  (statusCode == 200) else  {
                Log.error("Unable to make the rest call")
                return
            }
            Log.info("Successfuly made the rest call")
            
            do{
                guard  let jsonResult = try JSONSerialization
                    .jsonObject(with: data!,
                                options: JSONSerialization.ReadingOptions.mutableContainers)
                    as? NSDictionary else {
                        Log.debug("Failed to get the Json Result")
                        return
                }
                
                guard let jsonArray = jsonResult.value(forKey: apiFormat.key) as? NSArray else {
                    Log.debug("Failed to get the Json Array")
                    return
                }
                var podcastsAPI = [PodcastFromAPI]()
                for json in jsonArray {
                    let podcastData = json as! [String: AnyObject]
                    
                    
                    if (podcastData["collectionName"] as! String == (podcastData["artistName"] as! String)) {
                        continue
                    }
                    
                    guard let podcastTitle = podcastData[apiFormat.podcastTitle] as? String else {
                        return
                    }
                    
                    guard let podcasrUrl =  podcastData[apiFormat.feedUrl] as? String else {
                        return
                    }
                    
                    guard let podcastImage =  podcastData[apiFormat.podcastImage] as?String else {
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
                
            } catch {
                Log.error("Error with Json: \(error)")
            }
        }
        
        task.resume()
    }
    
    func savePodcastToCoreDataFromItuneAPI (_rssFeed: String) {
        CoreDataXMLParser(url: _rssFeed)
        self.performSegue(withIdentifier: Segues.segueFromItuneAPIToPodcast, sender: self)
    }
    
    func segueToAddUrl() {
        performSegue(withIdentifier: Segues.segueFromItuneWebToAddUrl, sender: self)
    }
    
}
