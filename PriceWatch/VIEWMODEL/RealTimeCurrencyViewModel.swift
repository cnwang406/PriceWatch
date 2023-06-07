//
//  RealTimeCurrencyViewModel.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/19.
//

import SwiftUI

@MainActor
class RealTimeCurrencyViewModel: ObservableObject {
    var dm = CurrencyModel.share
    @Published var currencies = RTCurrency()
    @Published var apiCurrencies = APILayerCurrency(success: false, timestamp: 0, base: "TWD", date: "1972-12-19", rates: ["USD": 0.0])
    @Published var loading: Bool = false
    @Published var latestDataTime: String = ""
    @Published var currency : [MyCurrencyModel] = []
    
//    @Published var basedDollar: Dollars = .TWD
    @Published var basedDollar: Dollars?
    @Published var baseMoney: Double = 1.0
    @Published var baseRate : Double = 1.0
    @Published var latestRealTimeUpdate: String = ""
//    @Published var moneyEntered: Double = 1.0
    func reload() async{
        loading = true
        if basedDollar == nil {
            basedDollar = .TWD
        }
        dm.baseDollar = basedDollar!
        dm.load()
        await dm.reload(fetchType: .realtime)
        self.currencies = dm.rtCurrencies
        self.apiCurrencies = dm.apiCurrencies
        self.currency = dm.currency
        
        let date = (self.currencies["USDTWD"]?.utc ?? "1972-12-19 19:30:00").formDateFromUTC()
        
        self.latestRealTimeUpdate = date.toString(timezone: "ASIA/TAIPEI")
        loading = false
        
        calculate()
        
    }
    
    func edit( CheckCurrency:  MyCurrencyModel) {
        let name = CheckCurrency.name.rawValue
        basedDollar = CheckCurrency.name
        for  idx in self.currency.indices {
            if currency[idx].name.rawValue == name {
                print ("Enable \(currency[idx].name.rawValue)")
                currency[idx].editable = true
                currency[idx].isBaseDollar = true
            } else {
                print ("disable \(currency[idx].name.rawValue)")
                currency[idx].editable = false
                currency[idx].isBaseDollar = false
            }
        }
//        calculate()
    }
    
    func dump(){
        for i in currency {
            print ("\(i.name.rawValue) e:\(i.editable ? "T" :"F"), b:\(i.isBaseDollar ? "T" : "F")")
        }
    }
    func calculate(){
        print ("Start to calculate")
        if basedDollar == nil {
            basedDollar = .TWD
        }
        print ("base dollar is \(basedDollar?.rawValue ?? "TWD")")
        
        print ("base money = \(baseMoney)")
        for  idx in self.currency.indices {
            
            currency[idx].money =  baseRate / currency[idx].rate  * baseMoney
//            print ("\(currency[idx].name.rawValue), rate = \(currency[idx].rate) / \(baseRate) * \(baseMoney) = \(currency[idx].money)")
        }
        
    }
    func setBaseDollar(_ dollar: Dollars){
        self.basedDollar = dollar
        for  idx in self.currency.indices {
            currency[idx].isBaseDollar =  currency[idx].name == dollar
//            print ("\(currency[idx].name.rawValue), rate = \(currency[idx].rate) / \(baseRate) * \(baseMoney) = \(currency[idx].money)")
        }
        
    }
    
    func getIsBaseDollar(dollar: Dollars) -> Bool {
        var result: Bool = false
        for cur in currency {
            if cur.name == dollar {
                result = cur.isBaseDollar
//                print ("\(cur.name.rawValue) --> baseDollar \(cur.isBaseDollar)")
            }
        }
        return result
        }
        
        
    }

