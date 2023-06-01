//
//  AlarmViewModel.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/1.
//

import SwiftUI

@MainActor
class AlarmViewModel: ObservableObject {
    @Published var watchList:[Dollars] = [.USD,.AUD,.JPY,.ZAR]
    @Published var alarmList: [AlarmModel] = []
    var dm = CurrencyModel.share
    func loadAlarms(){
        alarmList = []
        for wl in watchList {
            let xrate = dm.getXRate(dollar: wl)
            let newAlarm = AlarmModel(dollar: wl,low: xrate * 0.9 , high: xrate * 1.1 ,rate : xrate, buy: xrate * 0.95,activate: true)
            alarmList.append(newAlarm)
        }
    }
    
}


struct AlarmModel: Identifiable, Hashable{
    var id = UUID()
    var dollar : Dollars
    var low : Double = 0.0
    var high: Double = 1000.0
    var rate : Double = 0.0
    var buy : Double = 0.0
    var activate: Bool = false
    
}

var demoAlarmModel = AlarmModel(dollar: .USD, low: 27.0, high: 33.0, rate: 31.2, buy: 30.0, activate: true)
var demoAlarmModelL = AlarmModel(dollar: .AUD, low: 25.0, high: 30.0, rate: 24.3,buy: 27.0, activate: true)
var demoAlarmModelLL = AlarmModel(dollar: .AUD, low: 25.0, high: 30.0, rate: 20.3,buy: 27.0, activate: true)
var demoAlarmModelH = AlarmModel(dollar: .ZAR, low: 20.0, high: 25.0, rate: 27.2,buy: 22.0, activate: true)
var demoAlarmModelHH = AlarmModel(dollar: .ZAR, low: 20.0, high: 25.0, rate: 37.2,buy: 22.0, activate: true)
