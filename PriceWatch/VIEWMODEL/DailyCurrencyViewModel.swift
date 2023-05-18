//
//  DailyCurrencyViewModel.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/18.
//

import SwiftUI

@MainActor
class DailyCurrencyViewModel: ObservableObject {
    var dm = CurrencyModel.share
    @Published var currencies: [CurrencyElement] = []
    @Published var loading: Bool = false
    func reload() async{
        loading = true
        await dm.reload()
        self.currencies = dm.currencies
        loading = false
    }
    
}
