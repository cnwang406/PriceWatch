//
//  Date+Extension.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/19.
//

import SwiftUI

extension Date {
   
    
    func toString(timezone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return  dateFormatter.string(from: self)
    }
    func format(fmt: String, timezone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fmt
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return  dateFormatter.string(from: self)
        
    }
}
