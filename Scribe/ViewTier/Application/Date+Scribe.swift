//
//  Date+Scribe.swift
//  Scribe
//
//  Created by Mikael Son on 9/29/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

extension Date {
    
    static func compareYears(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
    }
    
    static func compareMonths(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: Date()).year ?? 0
    }
    
    static func compareWeeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: Date()).weekOfYear ?? 0
    }
    
    static func compareDays(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
    static func compareHours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
    }
    
    static func compareMinutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
    }
    
    static func lastDayOfYear() -> Date? {
        // Get the current year
        let year = Calendar.current.component(.year, from: Date())
        // Get the first day of next year
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear)
            
            return lastOfYear
        } else {
            return nil
        }
    }
}
