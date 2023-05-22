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
    
    func reload() async{
        loading = true
        await dm.reload(fetchType: .realtime)
        self.currencies = dm.rtCurrencies
        self.apiCurrencies = dm.apiCurrencies
        self.currency = dm.currency

        
        let date = (self.currencies["USDTWD"]?.utc ?? "1972-12-19 19:30:00").formDateFromUTC()
        
        self.latestDataTime = date.toString(timezone: "ASIA/TAIPEI")
        loading = false
        
    }
}
