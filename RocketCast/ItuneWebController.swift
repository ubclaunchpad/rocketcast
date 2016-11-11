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
    }
    
}

extension ItuneWebController:ItuneWebDelegate,ItuneWebTableViewCellDelegate {
  
}
