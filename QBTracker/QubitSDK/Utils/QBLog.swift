//
//  QBLog.swift
//  QubitSDK
//
//  Created by Pavlo Davydiuk on 24/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import Foundation

enum QBLogType: String {
    case error = "[‼️]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case verbose = "[🔬]"
    case warning = "[⚠️]"
}

@objc
public enum QBLogLevel: Int {
    case disabled
    case error
    case info
    case debug
    case verbose
    case warning
}

class QBLog {
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var logLevel: QBLogLevel = QBLogLevel.disabled
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    static func error(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, type: QBLogType.error, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func info(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, type: QBLogType.info, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func debug(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, type: QBLogType.debug, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func verbose(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, type: QBLogType.verbose, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func warning(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: message, type: QBLogType.warning, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func mark(fileName: String = #file, line: Int = #line, funcName: String = #function) {
        QBLog.log(message: "", type: QBLogType.verbose, fileName: fileName, line: line, funcName: funcName)
    }
    
    private static func log(message: String, type: QBLogType, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        if logLevel == .disabled {
            return
        }
        
        switch (logLevel, type) {
        case (QBLogLevel.error, QBLogType.error):
            fallthrough
        case (QBLogLevel.warning, QBLogType.warning):
            fallthrough
        case (QBLogLevel.info, QBLogType.info):
            fallthrough
        case (QBLogLevel.verbose, _):
            fallthrough
        case (QBLogLevel.debug, _):
            guard let queue = String(cString: __dispatch_queue_get_label(nil), encoding: .utf8) else {
                print("\(Date().toString()) \(type.rawValue)[\(sourceFileName(filePath: fileName)):\(line)] \(funcName) -> \(message)")
                return
            }
            print("[\(queue)] \(Date().toString()) \(type.rawValue)[\(sourceFileName(filePath: fileName)):\(line)] \(funcName) -> \(message)")
        case (_, _):
            break
        }
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
