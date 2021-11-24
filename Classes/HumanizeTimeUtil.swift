//
//  HumanizeTimeUtil.swift
//  GCCoreUtils
//
//  Created by quan on 2021/11/23.
//

import Foundation

open class HumanizeTimeUtil {
    public struct Config {
        public let daysPerYear: Int
        public let daysPerMonth: Int
        public let yearDesc: String
        public let monthDesc: String
        public let weekDesc: String
        public let dayDesc: String
        public let hourDesc: String
        public let minDesc: String
        public let secondDesc: String
        public let justDesc: String
        public let pastDesc: String
        public let futureDesc: String
        public let shortSegment: Int
    }
    
    public struct TimeDescriptor {
        public enum PastOrFuture {
            case past
            case future
        }
        
        var years: Int?
        var months: Int?
        var weeks: Int?
        var days: Int?
        var hours: Int?
        var mins: Int?
        var seconds: Int?
        var pastOrFuture: PastOrFuture
        
        init(years: Int? = nil, months: Int? = nil, weeks: Int? = nil, days: Int? = nil, hours: Int? = nil, mins: Int? = nil, seconds: Int? = nil, pastOrFuture: PastOrFuture = .past) {
            self.years = years
            self.months = months
            self.weeks = weeks
            self.days = days
            self.hours = hours
            self.mins = mins
            self.seconds = seconds
            self.pastOrFuture = pastOrFuture
        }
    }
    
    public static var config = Config(
        daysPerYear: 365,
        daysPerMonth: 30,
        yearDesc: "年",
        monthDesc: "个月",
        weekDesc: "周",
        dayDesc: "天",
        hourDesc: "小时",
        minDesc: "分钟",
        secondDesc: "秒",
        justDesc: "刚刚",
        pastDesc: "前",
        futureDesc: "后",
        shortSegment: 1
    )
    
    public static let secondsPerDay: Int = 24 * 60 * 60
    
    public static let shared = HumanizeTimeUtil()
    
    
    open func shortString(
        for timestamp: Timestamp,
        at end: Timestamp = .seconds(Int(Date().timeIntervalSince1970))
    ) -> String {
        let duration = end.intSeconds() - timestamp.intSeconds()
        let descriptor = timeDescriptor(
            with: abs(duration),
            pastOrFuture: duration > 0 ? .past : .future
        )
        return shortString(from: descriptor)
    }
    
    open func shortString(for date: Date, at end: Date = Date()) -> String {
        let duration = end.timeIntervalSince(date)
        let descriptor = timeDescriptor(
            with: abs(duration),
            pastOrFuture: duration > 0 ? .past : .future
        )
        return shortString(from: descriptor)
    }
    
    open func fullString(
        for timestamp: Timestamp,
        at end: Timestamp = .seconds(Int(Date().timeIntervalSince1970))
    ) -> String {
        let duration = end.intSeconds() - timestamp.intSeconds()
        let descriptor = timeDescriptor(
            with: abs(duration),
            pastOrFuture: duration > 0 ? .past : .future
        )
        return fullString(from: descriptor)
    }
    
    open func fullString(for date: Date, at end: Date = Date()) -> String {
        let duration = end.timeIntervalSince(date)
        let descriptor = timeDescriptor(
            with: abs(duration),
            pastOrFuture: duration > 0 ? .past : .future
        )
        return fullString(from: descriptor)
    }
    
    open func shortString(from descriptor: TimeDescriptor) -> String {
        var result = ""
        var segment = 0
        if let years = descriptor.years, years > 0 {
            result += "\(years)\(Self.config.yearDesc)"
            segment += 1
        }
        
        if shouldReturnShortString(result: &result, segment: segment, pastOrFuture: descriptor.pastOrFuture) {
            return result
        }
        
        if let months = descriptor.months, months > 0 {
            result += "\(months)\(Self.config.monthDesc)"
            segment += 1
        }
        
        if shouldReturnShortString(result: &result, segment: segment, pastOrFuture: descriptor.pastOrFuture) {
            return result
        }
        
        if let weeks = descriptor.weeks, weeks > 0 {
            result += "\(weeks)\(Self.config.weekDesc)"
            segment += 1
        }
        
        if shouldReturnShortString(result: &result, segment: segment, pastOrFuture: descriptor.pastOrFuture) {
            return result
        }
        
        if let days = descriptor.days, days > 0 {
            result += "\(days)\(Self.config.dayDesc)"
            segment += 1
        }
        
        if shouldReturnShortString(result: &result, segment: segment, pastOrFuture: descriptor.pastOrFuture) {
            return result
        }
        
        if let hours = descriptor.hours, hours > 0 {
            result += "\(hours)\(Self.config.hourDesc)"
            segment += 1
        }
        
        if shouldReturnShortString(result: &result, segment: segment, pastOrFuture: descriptor.pastOrFuture) {
            return result
        }
        
        if let mins = descriptor.mins, mins > 0 {
            result += "\(mins)\(Self.config.minDesc)"
            segment += 1
        }
        
        if shouldReturnShortString(result: &result, segment: segment, pastOrFuture: descriptor.pastOrFuture) {
            return result
        }
        
        if result.isEmpty { return Self.config.justDesc }
        
        switch descriptor.pastOrFuture {
        case .past:
            result += Self.config.pastDesc
        case .future:
            result += Self.config.futureDesc
        }
        
        return result
    }
    
    open func fullString(from descriptor: TimeDescriptor) -> String {
        var result = ""
        if let years = descriptor.years, years > 0 {
            result += "\(years)\(Self.config.yearDesc)"
        }
        
        if let months = descriptor.months, months > 0 {
            result += "\(months)\(Self.config.monthDesc)"
        }
        
        if let weeks = descriptor.weeks, weeks > 0 {
            result += "\(weeks)\(Self.config.weekDesc)"
        }
        
        if let days = descriptor.days, days > 0 {
            result += "\(days)\(Self.config.dayDesc)"
        }
        
        if let hours = descriptor.hours, hours > 0 {
            result += "\(hours)\(Self.config.hourDesc)"
        }
        
        if let mins = descriptor.mins, mins > 0 {
            result += "\(mins)\(Self.config.minDesc)"
        }
        
        if result.isEmpty { return Self.config.justDesc }
        
        switch descriptor.pastOrFuture {
        case .past:
            result += Self.config.pastDesc
        case .future:
            result += Self.config.futureDesc
        }
        
        return result
    }
    
    open func timeDescriptor(with interval: TimeInterval, pastOrFuture: TimeDescriptor.PastOrFuture) -> TimeDescriptor {
        return timeDescriptor(with: Int(interval), pastOrFuture: pastOrFuture)
    }
    
    open func timeDescriptor(with interval: Int, pastOrFuture: TimeDescriptor.PastOrFuture) -> TimeDescriptor {
        let secondsPerYear = Self.config.daysPerYear * Self.secondsPerDay
        let secondsPerMonth = Self.secondsPerDay * Self.config.daysPerMonth
        let secondsPerWeek = Self.secondsPerDay * 7
        let secondsPerHour = 60 * 60
        let secondsPerMin = 60
        
        var duration = interval
        var descriptor = TimeDescriptor()
        if duration >= secondsPerYear {
            descriptor.years = (duration / secondsPerYear)
            duration = duration % secondsPerYear
        }
        
        if duration >= secondsPerMonth {
            descriptor.months = (duration / secondsPerMonth)
            duration = duration % secondsPerMonth
        }
        
        if duration >= secondsPerWeek {
            descriptor.weeks = (duration / secondsPerWeek)
            duration = duration % secondsPerWeek
        }
        
        if duration >= Self.secondsPerDay {
            descriptor.days = (duration / Self.secondsPerDay)
            duration = duration % Self.secondsPerDay
        }
        
        if duration >= secondsPerHour {
            descriptor.hours = (duration / secondsPerHour)
            duration = duration % secondsPerHour
        }
        
        if duration >= secondsPerMin {
            descriptor.mins = (duration / secondsPerMin)
            duration = duration % secondsPerMin
        }
        
        descriptor.seconds = duration
        descriptor.pastOrFuture = pastOrFuture
        
        return descriptor
    }
    
    private func shouldReturnShortString(result: inout String, segment: Int, pastOrFuture: TimeDescriptor.PastOrFuture) -> Bool {
        if segment >= Self.config.shortSegment {
            switch pastOrFuture {
            case .past:
                result += Self.config.pastDesc
            case .future:
                result += Self.config.futureDesc
            }
            return true
        }
        return false
    }
}
