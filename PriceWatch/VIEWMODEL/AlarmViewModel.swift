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
    static var share = AlarmViewModel()
    func loadAlarms(){
        //        alarmList = []
        //        for wl in watchList {
        //            let xrate = dm.getXRate(dollar: wl)
        //            let newAlarm = AlarmModel(dollar: wl,low: xrate * 0.9 , high: xrate * 1.1 ,rate : xrate, buy: xrate * 0.95,activate: true)
        //            alarmList.append(newAlarm)
        //        }
        alarmList = load()
        if alarmList == [] {
            for wl in watchList {
                let xrate = dm.getXRate(dollar: wl)
                let newAlarm = AlarmModel(dollar: wl,low: xrate * 0.9 , high: xrate * 1.1 ,rate : xrate, buy: xrate * 0.95,activate: true)
                alarmList.append(newAlarm)
            }
            
        }
    }
    func save() {
        //stock = UserDefaults(suiteName: groupIdentifier)?.string(forKey: "stock") ?? "聯穎光電"
        
        if let encodedUserDetails = try? JSONEncoder().encode(self.alarmList) {
            UserDefaults.standard.set(encodedUserDetails, forKey: "alarmlist")
        }
        print ("AlarmList saved")
        
    }
    func load() -> [AlarmModel]{
        var ret : [AlarmModel] = []
        if let decodedData = UserDefaults.standard.object(forKey: "alarmlist") as? Data {
            if let userDetails = try? JSONDecoder().decode([AlarmModel].self, from: decodedData) {
                ret = userDetails
            }
        }
        return ret
    }
    
}



