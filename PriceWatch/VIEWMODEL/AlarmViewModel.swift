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
    @Published var alarmList: [AlarmModel] = []
    var dm = CurrencyModel.share
    static var share = AlarmViewModel()
    func loadAlarms(){
        alarmList = load()
        
        for al in alarmList {
            watchList.append(al.dollar)
        }
        print ("AlarmViewModel : load \(watchList) as watchList")
        if alarmList == [] {

            
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
    func addAlarm(_ am: AlarmModel){
        print ("add \(am.dollar)")
        self.alarmList.append(am)
        self.save()
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
    }
    
}



