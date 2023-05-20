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
    @Published var loading: Bool = false
    @Published var latestDataTime: String = ""
    func reload() async{
        loading = true
        await dm.reload(fetchType: .realtime)
        self.currencies = dm.rtCurrencies
        loading = false
        let date = Date().fromUTCString(utcString: self.currencies["USDTWD"]?.utc ?? "--")
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        // Convert Date to String
        self.latestDataTime = dateFormatter.string(from: date)
        
    }
}
