//
//  Double+Extension.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/4.
//

import SwiftUI

extension Double {
    func myFormat(digit: Int) -> String{
        let temp = roundTo(number: self, digit: digit)
        return self.formatted(.number.rounded(rule: .awayFromZero, increment: temp))
    }
    
    
    private func roundTo(number : Double, digit: Int) -> Double {
    
        let r =  (pow(10, digit - (String(Int(number)).count))) as NSNumber
        var k: Double = 0
        if number < 1 {
              k = Double (truncating: r) * 10
        } else {
            k = Double(truncating: r)
        }
        return  1 / k
    }
    

}
