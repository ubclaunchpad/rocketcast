//
//  DefaultLibraryExtensions.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation

extension String {
  func stringByRemovingAll(characters: [Character]) -> String {
    return String(self.characters.filter({ !characters.contains($0) }))
  }
  
  func stringByRemovingAll(subStrings: [String]) -> String {
    var resultString = self
    subStrings.map { resultString = resultString.stringByReplacingOccurrencesOfString($0, withString: "") }
    return resultString
  }
}