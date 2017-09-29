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
}
