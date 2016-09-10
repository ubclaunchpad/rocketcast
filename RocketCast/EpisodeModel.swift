//
//  EpisodeModel.swift
//  RocketCast
//
//  Created by James Park on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


class EpisodeModel {
    
    private var title: String?
    private var description:String?
    private var date:String?
    
    init(title:String, description:String, date:String) {
        self.title = title
        self.description = description
        self.date = date
    }
    init() {
        
    }
    
    
}