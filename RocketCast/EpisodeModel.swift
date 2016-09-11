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
    private var author:String?
    
    init(title:String, description:String, date:String, author:String) {
        self.title = title
        self.description = description
        self.date = date
        self.author = author
    }
    init() {
        
    }
    
    
}