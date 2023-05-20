//
//  Date+Extension.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/19.
//

import SwiftUI

extension Date {
    func fromUTCString(utcString: String) -> Date {
        
        let pattern2 = /(\d+)-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
        let pattern = /(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+):(?<second>\d+)/
        let utcs = "2023-05-17 08:59:59"
        if let result2 = try? pattern2.firstMatch(in: utcString) {
            print ("got it")
        }
        if let result = try? pattern.firstMatch(in: utcString) {
            let dc = DateComponents(calendar: .current, timeZone: .gmt, year: Int(result.year), month: Int(result.month), day: Int(result.day), hour: Int(result.hour), minute: Int(result.minute),second: Int(result.second))
            return Calendar.current.date(from: dc)!
        }
        return Date()
    }
}
