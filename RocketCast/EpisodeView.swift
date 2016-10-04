//
//  EpisodeView.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class EpisodeView: UIView, UITableViewDelegate, UITableViewDataSource {
    var viewDelegate: EpisodeViewDelegate?
    
    @IBOutlet weak var EpisodeTable: UITableView!
    
    @IBAction func segueToPlayer(sender: AnyObject) {
        viewDelegate?.segueToPlayer()
    }
    class func instancefromNib(frame: CGRect) -> EpisodeView {
        let view = UINib(nibName: "EpisodeView", bundle: nil).instantiateWithOwner(nil, options: nil)[0]
            as! EpisodeView
        view.frame = frame
        view.EpisodeTable.delegate = view
        view.EpisodeTable.dataSource = view
        view.EpisodeTable.allowsSelection = true
        view.EpisodeTable.separatorStyle = UITableViewCellSeparatorStyle.None
        view.EpisodeTable.backgroundColor = UIColor.clearColor()
        view.EpisodeTable.opaque = false
        return view
    }
    
    // returns an approiate number of rows depending on the section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    // Iiterates over every episode and creates a respective TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nib_name = UINib(nibName: EpisodeViewConstants.cellViewNibName, bundle:nil)
        tableView.registerNib(nib_name, forCellReuseIdentifier: EpisodeViewConstants.cellViewIdentifier)
        let cell = self.EpisodeTable.dequeueReusableCellWithIdentifier(EpisodeViewConstants.cellViewIdentifier, forIndexPath: indexPath) as! EpisodeViewTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.tag = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

