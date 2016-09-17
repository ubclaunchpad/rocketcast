//
//  UIExtensions.swift
//  RocketCast
//
//  Created by Mohamed Ali on 2016-09-17.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import Foundation
import UIKit

//Using this to extend various UI elements such UIButton, UIImage


//got from stackoverflow: http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
