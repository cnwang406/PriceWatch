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

struct RealTimeCurrencyElement: Identifiable, Codable {
    let id = UUID()
    let exrate: Double
    let utc: String

    enum CodingKeys: String, CodingKey {
        case exrate = "Exrate"
        case utc = "UTC"
    }
}

typealias RTCurrency = [String: RealTimeCurrencyElement]

enum DataType: String {
    case realtime
    case daily
}


@MainActor
class CurrencyModel: ObservableObject {
    static  var share = CurrencyModel()
    @Published var currencies: [CurrencyElement] = []
    @Published var rtCurrencies =  RTCurrency()
    @Published var loading : Bool = false
    @Published var latestUpdate: Double = Date().timeIntervalSince1970
    func reload(fetchType: DataType) async {
        self.loading = true
        let url = URL(string: "https://openapi.taifex.com.tw/v1/DailyForeignExchangeRates")!
        let url2 = URL(string: "https://tw.rter.info/capi.php")!
        let urlSession = URLSession.shared
        do {
            if fetchType == .daily {
                
                let (data, _) = try! await urlSession.data(from: url)
                self.currencies = try JSONDecoder().decode([CurrencyElement].self, from: data).reversed()
                latestUpdate = Date().timeIntervalSince1970
            } else {
                let (data2, _) = try! await urlSession.data(from:url2)
                self.rtCurrencies = try JSONDecoder().decode(RTCurrency.self, from: data2)
                latestUpdate = Date().timeIntervalSince1970
            }
            self.loading = false
        } catch {
            print ("Error loading ")
            self.loading = false
        }
        
        
        
    }
    
}
