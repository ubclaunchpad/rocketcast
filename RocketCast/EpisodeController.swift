//
//  EpisodeController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-31.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import CoreData

class EpisodeController: UIViewController {
    
    var episodes = ["#845 - TJ Dillashaw, Duane Ludwig & Bas Rutten",
                    "#844 - Andreas Antonopoulos",
                    "#843 - Tony Hinchcliffe",
                    "#842 - Chris Kresser",
                    "#841 - Greg Fitzsimmons",
                    "#840 - Donald Cerrone"]
    var sendEpisode: Episode?
    var mainView: EpisodeView?
    var coreData = CoreDataHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = EpisodeView.instancefromNib(viewSize)
        let episode = Episode(context: coreData.persistentContainer.viewContext)
        mainView?.episodesToView = episode.getAllEpisodes(moc: coreData.persistentContainer.viewContext)
        

        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Segues.segueFromEpisodeToPlayer) {
            let viewController: PlayerController = segue.destination as! PlayerController
            viewController.recievedEpisode = sendEpisode
        }
    }
}

extension EpisodeController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = episodes[(indexPath as NSIndexPath).row]
        
        return cell
    }
}

extension EpisodeController: EpisodeViewDelegate{
    func segueToPlayer () {
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)
    }
    
    func setSelectedEpisode (selectedEpisode: Episode) {
        let url = selectedEpisode.audioURL
        sendEpisode = selectedEpisode
        performSegue(withIdentifier: Segues.segueFromEpisodeToPlayer, sender: self)

    }
    
}
