//
//  DefaultLibraryExtensions.swift
//  RocketCast
//
//  Created by Milton Leung on 2016-09-10.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit


//from stackoverflow:  http://stackoverflow.com/questions/28059543/swift-replace-multiple-characters-in-string
extension String {
    func stringByRemovingAll(_ subStrings: [String]) -> String {
        var resultString = self
        subStrings.map { resultString = resultString.replacingOccurrences(of: $0, with: "") }
        return resultString
    }
    
    // http://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
    func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.unicode, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
}


