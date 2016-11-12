//
//  Log.swift
//  PollingApp
//
//  Created by Odin on 2016-07-16.
//  Copyright © 2016 Gabriel Uribe. All rights reserved.
//

import Foundation

//RC-16

class Log {
    
    /**
     Used for when you're doing tests. Testing log should be removed before commiting
     
     How to use: Log.test("this is my message")
     Output: 13:51:38.487 TEST  @@@@ in InputNameViewController.swift:addContainerToVC():77:: this is test
     
     To change the log level, visit the LogLevel enum
     
     - Parameter logMessage: The message to show
     - Parameter classPath: automatically generated based on the class that called this function
     - Parameter functionName: automatically generated based on the function that called this function
     - Parameter lineNumber: automatically generated based on the line that called this function
     */
    static func test(_ logMessage: String, classPath: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        let fileName = URLUtil.getNameFromStringPath(classPath)
        if LogLevel.lvl <= LogLevelChoices.TEST {
            print("\(Date().timeStamp()) TEST  @@@@ in \(fileName):\(functionName):\(lineNumber):: \(logMessage)")
        }
    }
    
    /**
     Used when something catastrophic just happened. Like app about to crash, app state is inconsistent, or possible data corruption
     
     How to use: Log.error("this is error")
     Output: 13:51:38.487 ERROR #### in InputNameViewController.swift:addContainerToVC():76:: this is error
     
     To change the log level, visit the LogLevel enum
     
     - Parameter logMessage: The message to show
     - Parameter classPath: automatically generated based on the class that called this function
     - Parameter functionName: automatically generated based on the function that called this function
     - Parameter lineNumber: automatically generated based on the line that called this function
     */
    static func error(_ logMessage: String, classPath: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        let fileName = URLUtil.getNameFromStringPath(classPath)
        if LogLevel.lvl <= LogLevelChoices.ERROR {
            print("\(Date().timeStamp()) ERROR #### in \(fileName):\(functionName):\(lineNumber):: \(logMessage)")
        }
    }
    
    /**
     Used when something went wrong, but the app can still function
     
     How to use: Log.warn("this is warn")
     Output: 13:51:38.487 WARN  ###  in InputNameViewController.swift:addContainerToVC():75:: this is warn
     
     To change the log level, visit the LogLevel enum
     
     - Parameter logMessage: The message to show
     - Parameter classPath: automatically generated based on the class that called this function
     - Parameter functionName: automatically generated based on the function that called this function
     - Parameter lineNumber: automatically generated based on the line that called this function
     */
    static func warn(_ logMessage: String, classPath: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        let fileName = URLUtil.getNameFromStringPath(classPath)
        if LogLevel.lvl <= LogLevelChoices.WARN {
            print("\(Date().timeStamp()) WARN  ###  in \(fileName):\(functionName):\(lineNumber):: \(logMessage)")
        }
    }
    
    /**
     Used when you want to show information like username or question asked
     
     How to use: Log.info("this is info")
     Output: 13:51:38.486 INFO  ##   in InputNameViewController.swift:addContainerToVC():74:: this is info
     
     To change the log level, visit the LogLevel enum
     
     - Parameter logMessage: The message to show
     - Parameter classPath: automatically generated based on the class that called this function
     - Parameter functionName: automatically generated based on the function that called this function
     - Parameter lineNumber: automatically generated based on the line that called this function
     */
    static func info(_ logMessage: String, classPath: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        let fileName = URLUtil.getNameFromStringPath(classPath)
        if LogLevel.lvl <= LogLevelChoices.INFO {
            print("\(Date().timeStamp()) INFO  ##   in \(fileName):\(functionName):\(lineNumber):: \(logMessage)")
        }
    }
    
    /**
     Used for when you're rebugging and you want to follow what's happening/.
     
     How to use: Log.debug("this is debug")
     Output: 13:51:38.485 DEBUG #    in InputNameViewController.swift:addContainerToVC():73:: this is debug
     
     To change the log level, visit the LogLevel enum
     
     - Parameter logMessage: The message to show
     - Parameter classPath: automatically generated based on the class that called this function
     - Parameter functionName: automatically generated based on the function that called this function
     - Parameter lineNumber: automatically generated based on the line that called this function
     */
    static func debug(_ logMessage: String, classPath: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        let fileName = URLUtil.getNameFromStringPath(classPath)
        if LogLevel.lvl <= LogLevelChoices.DEBUG {
            print("\(Date().timeStamp()) DEBUG #    in \(fileName):\(functionName):\(lineNumber):: \(logMessage)")
        }
    }
    
    
}

enum LogLevelChoices {
    static let DEBUG = 1
    static let INFO = 2
    static let WARN = 3
    static let ERROR = 4
    static let TEST = 5
}


class URLUtil {
    
    static func getNameFromStringPath(_ stringPath: String) -> String {
        //URL sees that "+" is a " "
        let stringPath = stringPath.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: stringPath)
        return url!.lastPathComponent
    }
    
    static func getNameFromURL(_ url: URL) -> String {
        return url.lastPathComponent
    }
}

// I moved this to Constants
///**
// A log level of debug will print out all levels above it.
// So a log level of WARN will print out WARN, ERROR, and TEST
// */
//enum LogLevel {
//    static let lvl = LogLevelChoices.DEBUG
//}


extension Date {
    
    func hour() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.hour, from: self)
        let hour = components.hour
        return hour!
    }
    
    
    func minute() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.minute, from: self)
        let minute = components.minute
        return minute!
    }
    
    func timeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: self)
    }
    
    func timeStampAMPM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        return formatter.string(from: self)
    }
    
    func detailedTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' EEEE, MMM d"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        
        return formatter.string(from: self)
    }
}
