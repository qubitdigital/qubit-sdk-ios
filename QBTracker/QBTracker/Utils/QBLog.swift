//
//  QBLog.swift
//  QBTracker
//
//  Created by Pavlo Davydiuk on 24/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

enum QBLogLevel: String {
    case error = "[‼️]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case verbose = "[🔬]"
    case warning = "[⚠️]"
}

class QBLog {
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    static func error(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, event: QBLogLevel.error, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func info(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, event: QBLogLevel.info, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func debug(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, event: QBLogLevel.debug, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func verbose(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, event: QBLogLevel.verbose, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func warning(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, event: QBLogLevel.warning, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func mark(fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: "", event: QBLogLevel.verbose, fileName: fileName, line: line, funcName: funcName)
    }
    
    private static func log(message: String, event: QBLogLevel, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(funcName) -> \(message)")
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        
        if let lastComponent = components.last {
            return lastComponent
        }
        return ""
    }
}

internal extension Date {
    func toString() -> String {
        return QBLog.dateFormatter.string(from: self as Date)
    }
}
