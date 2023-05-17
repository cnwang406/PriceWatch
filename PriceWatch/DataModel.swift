// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currency = try? JSONDecoder().decode(Currency.self, from: jsonData)

import SwiftUI
// MARK: - CurrencyElement
struct CurrencyElement: Identifiable, Codable {
    let id = UUID()
    let date, usdNtd, rmbNtd, eurUsd: String
    let usdJpy, gbpUsd, audUsd, usdHkd: String
    let usdRmb, usdZar, nzdUsd: String

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case usdNtd = "USD/NTD"
        case rmbNtd = "RMB/NTD"
        case eurUsd = "EUR/USD"
        case usdJpy = "USD/JPY"
        case gbpUsd = "GBP/USD"
        case audUsd = "AUD/USD"
        case usdHkd = "USD/HKD"
        case usdRmb = "USD/RMB"
        case usdZar = "USD/ZAR"
        case nzdUsd = "NZD/USD"
    }
}

typealias Currency = [CurrencyElement]

class CurrencyModel: ObservableObject {
    @Published var currencies: [CurrencyElement] = []
    @Published var loading : Bool = false
    
    func reload() async {
        self.loading = true
        let url = URL(string: "https://openapi.taifex.com.tw/v1/DailyForeignExchangeRates")!
        let urlSession = URLSession.shared
        do {
            let (data, response) = try! await urlSession.data(from: url)
            self.currencies = try JSONDecoder().decode([CurrencyElement].self, from: data).reversed()
            self.loading = false
        } catch {
            print ("Error loading ")
            self.loading = false
        }
        
    }
    
}
