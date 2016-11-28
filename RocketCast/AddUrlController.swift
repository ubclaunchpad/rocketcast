//
//  AddUrlController.swift
//  RocketCast
//
//  Created by Mohamed Ali on 2016-10-29.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit

class AddUrlController: UIViewController {
    
    var mainView: AddUrlView?

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
        mainView = AddUrlView.instancefromNib(viewSize)
        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
    }
    
}

extension AddUrlController:AddUrlViewDelegate{
    func addPodcast(webUrl: String) {
        print(webUrl)
        CoreDataXMLParser(url:webUrl)
        self.performSegue(withIdentifier: Segues.segueFromAddUrlToPodcastList, sender: self)
    }
}
