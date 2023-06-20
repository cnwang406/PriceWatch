//
//  AlarmModel.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/4.
//

import SwiftUI

let alarmGaugeGradient = Gradient(colors: [.red, .orange, .blue, .green])
func ratePosition(item: AlarmModel) -> (Double, AlarmStatus) {
    
    let width = item.high * 1.1 - item.low * 0.9
    let ratio = (item.rate - item.low * 0.9) / width
    var status: AlarmStatus = .tooLow
    if item.rate < item.low {
        status = .tooLow
    } else if item.rate <= item.buy {
        status = .lowerThenBuy
    } else if item.rate < item.high {
        status = .higherThenBuy
    } else {
        status = .tooHigh
    }
        
    return (ratio, status)
    
}

func statusColor(status: AlarmStatus) -> Color {
    switch status {
    case .tooHigh:
        return .green
    case .higherThenBuy:
        return .blue
    case .lowerThenBuy:
        return .orange
    case .tooLow:
        return .red
    }
}




struct AlarmModel: Identifiable, Hashable,Codable{
    var id = UUID()
    var dollar : Dollars
    var low : Double = 0.0
    var high: Double = 1000.0
    var rate : Double = 0.0
    var buy : Double = 0.0
    var activate: Bool = false
    var tooLow: Bool = false
    var tooHigh: Bool = false
    
}

var demoAlarmModel = AlarmModel(dollar: .USD, low: 27.0, high: 33.0, rate: 31.2, buy: 30.0, activate: true)
var demoAlarmModelL = AlarmModel(dollar: .AUD, low: 25.0, high: 30.0, rate: 24.3,buy: 27.0, activate: true)
var demoAlarmModelLL = AlarmModel(dollar: .AUD, low: 25.0, high: 30.0, rate: 20.3,buy: 27.0, activate: true, tooLow: true, tooHigh: false)
var demoAlarmModelH = AlarmModel(dollar: .ZAR, low: 20.0, high: 25.0, rate: 27.2,buy: 22.0, activate: true)
var demoAlarmModelHH = AlarmModel(dollar: .ZAR, low: 20.0, high: 25.0, rate: 37.2,buy: 22.0, activate: true, tooLow: false, tooHigh: true)
var demoAlarmModelNotExist = AlarmModel(dollar: .CNY, low: 20.0, high: 25.0, rate: 37.2,buy: 22.0, activate: true)
