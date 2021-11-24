//
//  DateUtil.swift
//  GCCoreUtils
//
//  Created by quan on 2021/11/23.
//

import Foundation

open class DateUtil {
    fileprivate static var formatterCaches: [String : DateFormatter] = [:]
    
    public enum FormatterType: String {
        case generic_HHmm =                 "HH:mm"
        case generic_HHmmss =               "HH:mm:ss"
        
        case cn_MMdd =                      "MM月dd日"
        case cn_yyyyMM =                    "yyyy年MM月"
        case cn_yyyyMMdd =                  "yyyy年MM月dd日"
        case cn_yyyyMMddHHmmss =            "yyyy年MM月dd日 HH:mm:ss"
        
        case minus_MMdd =                   "MM-dd"
        case minus_yyyyMM =                 "yyyy-MM"
        case minus_yyyyMMdd =               "yyyy-MM-dd"
        case minus_yyyyMMddHHmmss =         "yyyy-MM-dd HH:mm:ss"
        
        case slash_MMdd =                   "MM/dd"
        case slash_MMddyyyy =               "MM/dd/yyyy"
    }
    
    public static func date(from timestamp: Timestamp) -> Date {
        switch timestamp {
        case .seconds(let secs):
            return Date(timeIntervalSince1970: TimeInterval(secs))
        case .milliSecs(let milliSecs):
            return Date(timeIntervalSince1970: TimeInterval(milliSecs / 1000))
        case .interval(let interval):
            return Date(timeIntervalSince1970: interval)
        }
    }
    
    private static func safeGetCachedFormatter(_ pattern: String) -> DateFormatter {
        if Thread.isMainThread {
            var formatter = formatterCaches[pattern]
            if formatter == nil {
                formatter = DateFormatter()
                formatter!.dateFormat = pattern
                formatterCaches[pattern] = formatter!
            }
            return formatter!
        }
        else {
            var formatter: DateFormatter?
            DispatchQueue.main.sync {
                formatter = formatterCaches[pattern]
                if formatter == nil {
                    formatter = DateFormatter()
                    formatter!.dateFormat = pattern
                    formatterCaches[pattern] = formatter!
                }
            }
            return formatter!
        }
    }
}

public extension DateUtil {
    static func date(from str: String, formatterType: FormatterType) -> Date? {
        return date(from: str, formatterPattern: formatterType.rawValue)
    }
    
    static func date(from str: String, formatterPattern: String) -> Date? {
        return date(from: str, formatter: safeGetCachedFormatter(formatterPattern))
    }
    
    static func date(from str: String, formatter: DateFormatter) -> Date? {
        return formatter.date(from: str)
    }
}


public extension DateUtil {
    static func string(from timestamp: Timestamp, formatterType: FormatterType) -> String {
        return string(
            from: date(from: timestamp),
            formatterPattern: formatterType.rawValue
        )
    }
    
    static func string(from timestamp: Timestamp, formatterPattern: String) -> String {
        return string(
            from: date(from: timestamp),
            formatterPattern: formatterPattern
        )
    }
    
    static func string(from timestamp: Timestamp, formatter: DateFormatter) -> String {
        return string(
            from: date(from: timestamp),
            formatter: formatter
        )
    }
    
    static func string(from date: Date, formatterType: FormatterType) -> String {
        return string(from: date, formatterPattern: formatterType.rawValue)
    }
    
    static func string(from date: Date, formatterPattern: String) -> String {
        let formatter = safeGetCachedFormatter(formatterPattern)
        return string(from: date, formatter: formatter)
    }
    
    static func string(from date: Date, formatter: DateFormatter) -> String {
        return formatter.string(from: date)
    }
}
