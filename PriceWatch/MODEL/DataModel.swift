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

struct APILayerCurrency: Identifiable, Codable, Hashable {
    var id = UUID()
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
    
}



enum DataType: String {
    case realtime
    case daily
    
}

enum Dollars: String, CaseIterable  {
    case TWD = "TWD"
    case USD = "USD"
    case JPY = "JPY"
    case EUR = "EUR"
    case AUD = "AUD"
    case GBP = "GBP"
    case ARS = "ARS"
    case ZAR = "ZAR"
    case CNY = "CNY"
    
}

struct MyCurrencyModel: Identifiable {
    let id = UUID()
    let timestamp: Double
    let name: Dollars
    let rate: Double
    let vaildate: Bool
}


@MainActor
class CurrencyModel: ObservableObject {
    static  var share = CurrencyModel()
    @Published var currencies: [CurrencyElement] = []
    @Published var rtCurrencies =  RTCurrency()
    @Published var apiCurrencies = APILayerCurrency(success: false, timestamp: 0, base: "TWD", date: "1972-12-19", rates: ["USD": 0.0])
    @Published var loading : Bool = false
    @Published var latestUpdate: Double = Date().timeIntervalSince1970
    @Published var currency: [MyCurrencyModel] = []
    func reload(fetchType: DataType) async {
        self.loading = true
        let url = URL(string: "https://openapi.taifex.com.tw/v1/DailyForeignExchangeRates")!
        let url2 = URL(string: "https://tw.rter.info/capi.php")!
        let url3 = URL(string: apiLayerURL + "?base=TWD&symbols=CNY,EUR")!
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
        parse()
    }
    
    func parse(){
        
        // get USDTWD
        print (rtCurrencies["USDJPY"])
        currency = []
        print ("USDTWD")
        print (rtCurrencies["USDTWD"]?.utc.formDateFromUTC().timeIntervalSince1970 ?? 0.0)
        print (rtCurrencies["USDTWD"]?.exrate ?? 1.0)
        let usdToTwd = rtCurrencies["USDTWD"]?.exrate ?? 1.0
        let rate = rtCurrencies["USDTWD"]?.exrate ?? 0.0
        let vaildate =  (rate != 0.0)  && (usdToTwd != 0.0)
        var newCurrency = MyCurrencyModel(timestamp: rtCurrencies["USDTWD"]?.utc.formDateFromUTC().timeIntervalSince1970 ?? 0.0, name: Dollars(rawValue: "USDTWD") ?? .TWD, rate: rate , vaildate: (rate != 0.0)  && (usdToTwd != 0.0))
        
        // enumerate others, convert to TWD
        for dollar in Dollars.allCases{
            
            let xname = "USD" + dollar.rawValue
            let rate = rtCurrencies[xname]?.exrate ?? 0.0
            let validate = (rate != 0.0)  && (usdToTwd != 0.0)
            let xrate = validate ?  usdToTwd / rate : 0.0
            print ("\(xname), rate = \(rate), validate = \(vaildate ? "T" : "F"), xrate = \(xrate) ")
            let newCurrency = MyCurrencyModel(timestamp: rtCurrencies[xname]?.utc.formDateFromUTC().timeIntervalSince1970 ?? 0.0, name: dollar, rate:xrate, vaildate: validate)
            
            currency.append(newCurrency)
    
        }
        
        
        
        
    }
    
    
}