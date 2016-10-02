//
//  EpisodeController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class EpisodeController: UIViewController {
    
    var episodes = ["#845 - TJ Dillashaw, Duane Ludwig & Bas Rutten",
                    "#844 - Andreas Antonopoulos",
                    "#843 - Tony Hinchcliffe",
                    "#842 - Chris Kresser",
                    "#841 - Greg Fitzsimmons",
                    "#840 - Donald Cerrone"]
    
    var mainView: EpisodeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let viewSize = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension EpisodeController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = episodes[indexPath.row]
        
        return cell
    }
}

extension EpisodeController: EpisodeViewDelegate{
    func segueToPlayer () {
        performSegueWithIdentifier(Segues.segueFromEpisodeToPlayer, sender: self)
    }
}