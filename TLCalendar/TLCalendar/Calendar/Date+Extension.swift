//
//  Date+Extension.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/3/1.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import Foundation

extension Date {
    
    func dateAfterMonth(_ month: Int) -> Date {
        var calencar = Calendar.current
        if let timezone = TimeZone(abbreviation: "EST") {
            calencar.timeZone = timezone
        }
        var componentsToAdd = DateComponents()
        componentsToAdd.month = month
        let dateAfterMonth = calencar.date(byAdding: componentsToAdd, to: self)
        return dateAfterMonth ?? Date()
    }
    
    // 每月天数
    func daysInMonth() -> Int {
        switch self.month() {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 2:
            return self.isLeapYear() ? 29 : 28
        default:
            return 30
        }
    }
    
    // 是否闰年
    func isLeapYear() -> Bool {
        let year = self.year()
        if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            return true
        }
        return false
    }
    
    func begindayOfMonth() -> Date {
        return self.dateAfterDay(-self.day() + 1)
    }
    
    func dateAfterDay(_ day: Int) -> Date {
        var calencar = Calendar.current
        if let timezone = TimeZone(abbreviation: "EST") {
            calencar.timeZone = timezone
        }
        var componentsToAdd = DateComponents()
        componentsToAdd.day = day
        let dateAfterMonth = calencar.date(byAdding: componentsToAdd, to: self)
        return dateAfterMonth ?? Date()
    }
    
    func weekday() -> Int {
        var cal = Calendar.current
        if let timezone = TimeZone(abbreviation: "EST") {
            cal.timeZone = timezone
        }
        let com = cal.dateComponents([.weekday], from: self)
        return com.weekday!
    }

    func isSameDay(_ anotherDate: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: anotherDate)
        if components1.day == components2.day,
            components1.month == components2.month,
            components1.year == components2.year {
            return true
        }
        return false

    }

}

public extension Date {
    func dateAtStartOfDay() -> Date {
        var com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        com.hour = 0
        com.minute = 0
        com.second = 0
        return Calendar.current.date(from: com)!
    }
    
    func dateAtEndOfDay() -> Date {
        var com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        com.hour = 23
        com.minute = 59
        com.second = 59
        return Calendar.current.date(from: com)!
    }
    
    func isSameYearMonthDayWithToday() -> Bool {
        var com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        var comToday = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        if com.day == comToday.day, com.month == comToday.month, com.year == comToday.year {
            return true
        }
        return false
    }
    
    func day() -> Int {
        var cal = Calendar.current
        if let timezone = TimeZone(abbreviation: "EST") {
            cal.timeZone = timezone
        }
        //cal.timeZone = TimeZone(abbreviation: "EST") ?? TimeZone(secondsFromGMT: 28000)
        let com = cal.dateComponents([.day], from: self)
        return com.day!
    }
    
    func month() -> Int {
        var cal = Calendar.current
        if let timezone = TimeZone(abbreviation: "EST") {
            cal.timeZone = timezone
        }
        let com = cal.dateComponents([.month], from: self)
        return com.month!
    }
    
    func year() -> Int {
        var cal = Calendar.current
        if let timezone = TimeZone(abbreviation: "EST") {
            cal.timeZone = timezone
        }
        let com = cal.dateComponents([.year], from: self)
        return com.year!
    }
    
    func hour() -> Int {
        let com = Calendar.current.dateComponents([.hour], from: self)
        return com.hour!
    }
    
    func minute() -> Int {
        let com = Calendar.current.dateComponents([.minute], from: self)
        return com.minute!
    }
    
    func second() -> Int {
        let com = Calendar.current.dateComponents([.second], from: self)
        return com.second!
    }
    
    func string(format: String = "yyyy-MM-dd") -> String {
        let fmt = DateFormatter()
        if let timezone = TimeZone(abbreviation: "EST") {
            fmt.timeZone = timezone
        }
        fmt.dateFormat = format

        return fmt.string(from: self)
    }
    
    static func formatDate(_ time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"

        return dateFormatter.date(from: time) ?? Date()
    }
}
