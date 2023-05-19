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
    func reload() async{
        loading = true
        await dm.reload(fetchType: .realtime)
        self.currencies = dm.rtCurrencies
        loading = false
    }
}
