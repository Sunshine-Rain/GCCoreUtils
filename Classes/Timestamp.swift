//
//  BasicType.swift
//  GCCoreUtils
//
//  Created by quan on 2021/11/23.
//

import Foundation

/// Timestamp since 1970
public enum Timestamp {
    case seconds(_ secs: Int)
    case milliSecs(_ milliSecs: Int)
    case interval(_ interval: TimeInterval)
    
    public func intSeconds() -> Int {
        switch self {
        case .seconds(let secs):
            return secs
        case .milliSecs(let milliSecs):
            return milliSecs / 1000
        case .interval(let interval):
            return Int(interval)
        }
    }
}
