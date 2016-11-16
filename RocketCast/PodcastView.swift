//
//  PodcastView.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit


class PodcastView: UIView, UICollectionViewDelegate,
UICollectionViewDataSource {
    var viewDelegate: PodcastViewDelegate?
    
    @IBOutlet weak var podcastView: UICollectionView!
    @IBOutlet weak var viewTitle: UILabel!
    
    var podcastsToView = [Podcast]() {
        didSet {
            podcastView.reloadData()
        }
    }
    
    var inDeleteMode: Bool = false {
        didSet {
            podcastView.reloadData()
        }
    }
    
    @IBAction func addNewPodcastBtnPressed(_ sender: AnyObject) {
        viewDelegate?.segueToItuneWeb()
    }

    class func instancefromNib(_ frame: CGRect) -> PodcastView {
        let view = UINib(nibName: "PodcastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0]
            as! PodcastView
        view.frame = frame
        
        view.podcastView.delegate = view
        view.podcastView.dataSource = view
        view.podcastView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 12)
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let podcastCell = UINib(nibName: "PodcastsTitleCollectionViewCell", bundle: nil)
            podcastView.register(podcastCell, forCellWithReuseIdentifier: "podcastTitleCell")
            
            if let cell = self.podcastView.dequeueReusableCell(withReuseIdentifier: "podcastTitleCell", for: indexPath) as? PodcastsTitleCollectionViewCell {
                cell.titleLabel.text = "Podcasts"
                cell.isUserInteractionEnabled = false
                return cell
            }
            return UICollectionViewCell()
            
        } else {
            let podcastCell = UINib(nibName: "PodcastViewCollectionViewCell", bundle: nil)
            podcastView.register(podcastCell, forCellWithReuseIdentifier: "podcastCell")
            
            if let cell = self.podcastView.dequeueReusableCell(withReuseIdentifier: "podcastCell", for: indexPath) as? PodcastViewCollectionViewCell {
                var width: Int!
                if UIScreen.main.bounds.size.width >= 414 {
                    width = 170
                } else if UIScreen.main.bounds.size.width >= 375 {
                    width = 150
                } else {
                    width = 130
                }
                cell.size = width
                cell.setStyling()
                if self.inDeleteMode {
                    cell.addDeleteButton()
                    cell.viewDelegate = self.viewDelegate
                } else {
                    cell.removeDeleteButton()
                }
                
                cell.podcast = podcastsToView[indexPath.row]
                return cell
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : podcastsToView.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width: Int!
        var height: Int!
        if UIScreen.main.bounds.size.width >= 414 {
            width = 185
            height = 220
        } else if UIScreen.main.bounds.size.width >= 375 {
            width = 165
            height = 205
        } else {
            width = 144
            height = 180
        }
        
        return indexPath.section == 0 ? CGSize(width: self.podcastView.frame.width, height: 50) : CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewDelegate?.setSelectedPodcastAndSegue(selectedPodcast: podcastsToView[indexPath.row])
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section:Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets.zero : UIEdgeInsets.zero
    }
}
