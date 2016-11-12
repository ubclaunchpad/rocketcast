//
//  ItuneWebView.swift
//  RocketCast
//
//  Created by James Park on 2016-11-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class ItuneWebView: UIView, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var viewDelegate: ItuneWebDelegate?
    var discoveredPodcasts = [PodcastFromAPI]()
    @IBOutlet weak var podcastTable: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    class func instancefromNib(_ frame: CGRect) -> ItuneWebView {
        let view = UINib(nibName: "ItuneWebView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! ItuneWebView
        view.frame = frame
        view.podcastTable.delegate = view
        view.podcastTable.dataSource = view
        view.podcastTable.allowsSelection = true
        view.podcastTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        view.podcastTable.separatorColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        view.podcastTable.backgroundColor = UIColor.clear
        view.podcastTable.isOpaque = false
        
        view.searchBar.delegate = view
        view.searchBar.placeholder = "Look for a podcast"
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPodcasts.count
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 94
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib_name = UINib(nibName:"ItuneWebTableViewCell", bundle:nil)
        tableView.register(nib_name, forCellReuseIdentifier: "podcastCell")
        let cell = self.podcastTable.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as! ItuneWebTableViewCell
        
        cell.updateUI(podcast: discoveredPodcasts[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let rssfeed = discoveredPodcasts[indexPath.row].rssFeed as? String {
             viewDelegate?.savePodcastToCoreDataFromItuneAPI(_rssFeed: rssfeed)
        }
       
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewDelegate?.getPodcastsFromItuneAPI(_inputString: searchText)
    }
    
}
