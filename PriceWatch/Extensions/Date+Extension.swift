//
//  Date+Extension.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/19.
//

import SwiftUI

extension Date {
    func fromUTCString(utcString: String) -> Date {
        
        let pattern2 = /d{4}-d{2}-d{2} d{2}:d{2}:d{2}/
        let pattern = /(?<year>d{4})-(?<month>d{2})-(?<day>d{2}) (?<hour>d{2}):(?<min>d{2}):(?<sec>d{2})/
        let utcs = "2023-05-17 08:59:59"
        if let result = try? pattern2.wholeMatch(in: utcs) {
            print("year: \(result.1)")
            print("month: \(result.2)")
        }
        return Date()
    }
}
