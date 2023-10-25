//
//  Date+Extensions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/9.
//

import Foundation

public extension Date {
    
    /// 时间格式化输出
    ///
    ///     Date().string(withFormat: "dd/MM/yyyy") -> "1/12/17"
    ///     Date().string(withFormat: "HH:mm") -> "23:50"
    ///     Date().string(withFormat: "dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    ///
    /// - Parameter format: Date format (default is "dd/MM/yyyy").
    /// - Returns: date string.
    func string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func stringZone(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    /// Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    var iso8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }
    
    init?(iso8601String: String) {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: iso8601String) else { return nil }
        self = date
    }
    
    ///
    ///     let date = Date(integerLiteral: 2017_12_25) // "2017-12-25 00:00:00 +0000"
    /// - Parameter value: Int value, e.g. 20171225, or 2017_12_25 etc.
    init?(integerLiteral value: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: String(value)) else { return nil }
        self = date
    }
    
    init?(string: String, withFormat format: String = "dd/MM/yyyy HH:mm") {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        guard let date = formatter.date(from: string) else { return nil }
        self = date
    }
    
    func stringAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)
        
        if let year = components.year, year >= 1 {
            return "\(year) years ago"
        } else if let month = components.month, month >= 1 {
            return "\(month) months ago"
        } else if let day = components.day, day >= 1 {
            return "\(day) days ago"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour) hours ago"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute) minutes ago"
        } else {
            return "just now"
        }
    }
    
}
