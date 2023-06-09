//
//  AlarmViewModel.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/1.
//

import SwiftUI

@MainActor
class AlarmViewModel: ObservableObject {
//    @Published var watchList:[Dollars] = [.USD,.AUD,.JPY,.ZAR]
    @Published var watchList:[Dollars] = []

    @Published var alarmList: [AlarmModel] = [] // store in userdefault
    var dm = CurrencyModel.share
    static var share = AlarmViewModel()
    @Published var alarmSet: Set<String> = []
    @Published var nonAlarmSet: Set<String> = []
    @Published var loading: Bool = false
    
    
    func loadAlarms(){
        loading = true
        
        alarmList = load()
        alarmSet = []
        nonAlarmSet = []
        for al in Dollars.allCases {
            nonAlarmSet.insert(al.rawValue)
        }
        
        for al in alarmList {
            alarmSet.insert(al.dollar.rawValue)
            nonAlarmSet.remove(al.dollar.rawValue)
        }

        print ("AlarmViewModel : load \(watchList) as watchList")
        if alarmList == [] {

        }
        loading = false
    }
    func save() {
        
        if let encodedUserDetails = try? JSONEncoder().encode(self.alarmList) {
            UserDefaults.standard.set(encodedUserDetails, forKey: "alarmlist")
        }
        print ("AlarmList saved")
        loadAlarms()    // to refresh watchlist
    }
    
    
    func load() -> [AlarmModel]{
        var ret : [AlarmModel] = []
        if let decodedData = UserDefaults.standard.object(forKey: "alarmlist") as? Data {
            if let userDetails = try? JSONDecoder().decode([AlarmModel].self, from: decodedData) {
                ret = userDetails
            }
        }
        dm.loadFromMemory()
        return ret
    }
    func addAlarm(_ am: AlarmModel){
        print ("add \(am.dollar)")
        self.alarmList.append(am)
        self.save()
        self.loadAlarms()
    }
    
    func delAlarm(_ am: AlarmModel){
        print ("delete \(am.dollar)")
        print ("before delete, alarmList = \(alarmList)")
        
        do {
            try alarmList[alarmList.firstIndex(of: am)!].dollar
        } catch{
            print ("cannot find \(am.dollar)")
        }
        alarmList.remove(at: alarmList.firstIndex(of: am)!)
        
        
        print ("after delete, alarmList = \(alarmList)")
        self.save()
        self.loadAlarms()
    }
    
    func checkAlarmList(){
        loading = true
        dm.loadFromMemory()
        
        for idx in (alarmList.indices) {
            var al = alarmList[idx]
            let rate = dm.getXRate(dollar: al.dollar)
            alarmList[idx].tooHigh = rate >= al.high
            alarmList[idx].tooLow = rate <= al.low
            print ("rate = \(rate), al.high/buy/low = \(al.high), \(al.buy), \(al.low), tooHigh/tooLow = \(al.tooHigh),\(al.tooLow)")
            
        }
        self.save()
        self.loadAlarms()
        loading = false
    }
    
}



