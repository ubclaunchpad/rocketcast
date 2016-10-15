//
//  DefaultLibraryExtensions.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation


//from stackoverflow:  http://stackoverflow.com/questions/28059543/swift-replace-multiple-characters-in-string
extension String {
    func stringByRemovingAll(_ characters: [Character]) -> String {
        return String(self.characters.filter({ !characters.contains($0) }))
    }
    
    func stringByRemovingAll(_ subStrings: [String]) -> String {
        var resultString = self
        subStrings.map { resultString = resultString.replacingOccurrences(of: $0, with: "") }
        return resultString
    }
    
}
