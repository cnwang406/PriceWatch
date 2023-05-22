//
//  String+Extension.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/20.
//

import SwiftUI

extension String {
    func formDateFromUTC() -> Date {
        let pattern = /(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+):(?<second>\d+)/

        
        if let result = try? pattern.firstMatch(in: self) {
            let dc = DateComponents(calendar: .current, timeZone: .gmt, year: Int(result.year), month: Int(result.month), day: Int(result.day), hour: Int(result.hour), minute: Int(result.minute),second: Int(result.second))
            return Calendar.current.date(from: dc)!
        }
        return Date()
        
    }
}
