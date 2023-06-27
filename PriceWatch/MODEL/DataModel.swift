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

enum Dollars: String, CaseIterable, Codable,Hashable  {
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

func str2Dollar(fromStr: String) -> Dollars?{
    for dollar in Dollars.allCases {
        if fromStr == dollar.rawValue {
            return dollar
        }
    }
    return nil
}


struct MyCurrencyModel: Identifiable, Codable {
    var id = UUID()
    let timestamp: Double
    let name: Dollars
    let rate: Double
    let vaildate: Bool
    var isBaseDollar:Bool = false
    var editable: Bool = false
    var money: Double = 0.0
    
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
    @Published var baseDollar: Dollars = .TWD
    @Published var currency2: [MyCurrencyModel] = []

    
    func load(fetchType: DataType) async {
        print ("CurrencyModel loading")
        self.loading =  true
        print ("CurrencyModel load from memory")
        self.loadFromMemory()
        print ("CurrencyModel await load from cloud")
        await reloadFromCloud(fetchType: fetchType)
        
    }
    
    
    func reloadFromCloud(fetchType: DataType) async {
        self.loading = true
        print ("CurrencyModel.reloadFromCloud = \(self.loading)")
        let url = URL(string: "https://openapi.taifex.com.tw/v1/DailyForeignExchangeRates")!
        let url2 = URL(string: "https://tw.rter.info/capi.php")!
//        let url3 = URL(string: apiLayerURL + "?base=TWD&symbols=CNY,EUR")!
        let urlSession = URLSession.shared
        do {
            if fetchType == .daily {
                
                let (data, _) = try! await urlSession.data(from: url)
                self.currencies = try JSONDecoder().decode([CurrencyElement].self, from: data).reversed()
                latestUpdate = Date().timeIntervalSince1970
            } else {
                let (data2, _) = try await urlSession.data(from:url2)
                self.rtCurrencies = try JSONDecoder().decode(RTCurrency.self, from: data2)
                latestUpdate = Date().timeIntervalSince1970
            }
            self.loading = false
        } catch {
            print ("reloadFromCloud Error loading , [currency].count = \(self.currency.count)")
//            self.loadFromMemory()
            if self.currency.count == 0 {
                self.initialCurrency()
            }
            self.loading = false
        }
        parse()
        print ("CurrencyModel.loading = \(self.loading)")
    }
    
    func parse(bdollar: Dollars = .TWD){
        
        currency = []

        print (rtCurrencies["USDTWD"]?.utc.formDateFromUTC().timeIntervalSince1970 ?? 0.0)

        let usdToTwd = rtCurrencies["USDTWD"]?.exrate ?? 1.0
//        var baseDollarRate = 1.0
        let baseDollarRate = rtCurrencies["USD\(baseDollar.rawValue)"]?.exrate ?? 1.0
        
        
        
        for dollar in Dollars.allCases{
            
            let xname = "USD" + dollar.rawValue
            let rate = rtCurrencies[xname]?.exrate ?? 0.0
            let validate = (rate != 0.0)  && (usdToTwd != 0.0)
            let xrate = validate ?  baseDollarRate / rate : 0.0
//            let money = validate ? xrate * baseMoney  : 0.0
            let isBaseDollar = dollar == bdollar
//            print ("\(xname), rate = \(rate), validate = \(validate ? "T" : "F"), xrate = \(xrate) ,isBaseDollar = \(isBaseDollar)")
            let newCurrency = MyCurrencyModel(timestamp: rtCurrencies[xname]?.utc.formDateFromUTC().timeIntervalSince1970 ?? 0.0, name: dollar, rate:xrate, vaildate: validate, isBaseDollar: isBaseDollar,  money: 0.0)
            
            currency.append(newCurrency)
    
        }
        save()
    }
    
    func getXRate(dollar: Dollars) -> Double {
        var rate: Double = 0.0
        for d in currency {
            if d.name == dollar {
                rate = d.rate
            }
                
        }
        return rate
    }
    
    func resetBaseMoney() {
//        self.baseMoney = 1.0
    }
    
    func save() {
        //stock = UserDefaults(suiteName: groupIdentifier)?.string(forKey: "stock") ?? "聯穎光電"
        
        let userDefaults = UserDefaults.standard
        if let encodedUserDetails = try? JSONEncoder().encode(self.currency) {
           UserDefaults.standard.set(encodedUserDetails, forKey: "currency")
        }

    }
    func loadFromMemory() {
        var ret : [MyCurrencyModel] = []
        print ("load from userdefault")
        if let decodedData = UserDefaults.standard.object(forKey: "currency") as? Data {
            
                if let userDetails = try? JSONDecoder().decode([MyCurrencyModel].self, from: decodedData) {
                    ret = userDetails
                    self.currency = ret
                }
            
            if self.currency.count == 0 {
                print ("Fail to read userdefault")
                print ("initialize a new one,and save")
                self.initialCurrency()
            }
        }
//        return ret
        self.currency = ret
    }
    
    func initialCurrency(){
        var ret: [MyCurrencyModel] = []
        print ("initialCurrency...")
        for dollar in Dollars.allCases {
            let newDollar = MyCurrencyModel(timestamp: Date().timeIntervalSince1970 - 86400.0, name: dollar, rate: 1.0, vaildate: false)
            ret.append(newDollar)
        }
        self.currency = ret
        self.save()
    }
    
}


enum AllDollars: String, CaseIterable, Codable  {
    case FKP = "FKP"
    case ITL = "ITL"
    case CNH = "CNH"
    case LAK = "LAK"
    case ZMW = "ZMW"
    case AOA = "AOA"
    case TTD = "TTD"
    case NAD = "NAD"
    case USD = "USD"
    case SVC = "SVC"
    case MXN = "MXN"
    case IRR = "IRR"
    case SHP = "SHP"
    case ISK = "ISK"
    case BBD = "BBD"
    case LTC = "LTC"
    case MXV = "MXV"
    case DJF = "DJF"
    case LVL = "LVL"
    case NGN = "NGN"
    case AWG = "AWG"
    case JEP = "JEP"
    case UZS = "UZS"
    case HUX = "HUX"
    case MVR = "MVR"
    case TZS = "TZS"
    case IEP = "IEP"
    case KYD = "KYD"
    case STN = "STN"
    case PHP = "PHP"
    case UYU = "UYU"
    case FJD = "FJD"
    case CAD = "CAD"
    case MYR = "MYR"
    case HNL = "HNL"
    case CVE = "CVE"
    case SRD = "SRD"
    case SEK = "SEK"
    case EGP = "EGP"
    case CUP = "CUP"
    case GBP = "GBP"
    case CZK = "CZK"
    case STD = "STD"
    case IMP = "IMP"
    case XCD = "XCD"
    case LSL = "LSL"
    case WST = "WST"
    case TJS = "TJS"
    case KES = "KES"
    case KPW = "KPW"
    case FRF = "FRF"
    case MWK = "MWK"
    case TRY = "TRY"
    case BGN = "BGN"
    case BWP = "BWP"
    case GIP = "GIP"
    case SLL = "SLL"
    case CUC = "CUC"
    case CHF = "CHF"
    case BOB = "BOB"
    case BTC = "BTC"
    case BND = "BND"
    case XDR = "XDR"
    case PLN = "PLN"
    case VEF = "VEF"
    case SIT = "SIT"
    case BYN = "BYN"
    case LBP = "LBP"
    case BRX = "BRX"
    case LYD = "LYD"
    case GMD = "GMD"
    case XAU = "XAU"
    case YER = "YER"
    case AFN = "AFN"
    case AED = "AED"
    case CDF = "CDF"
    case BDT = "BDT"
    case CNY = "CNY"
    case SZL = "SZL"
    case SSP = "SSP"
    case HRK = "HRK"
    case MOP = "MOP"
    case LRD = "LRD"
    case DKK = "DKK"
    case SDG = "SDG"
    case NOK = "NOK"
    case RWF = "RWF"
    case SCR = "SCR"
    case KZT = "KZT"
    case SYP = "SYP"
    case RON = "RON"
    case AUD = "AUD"
    case MRO = "MRO"
    case AMD = "AMD"
    case MZN = "MZN"
    case ECS = "ECS"
    case PAB = "PAB"
    case SGD = "SGD"
//    case USD = "USD"
    case KRW = "KRW"
    case XPT = "XPT"
    case LKR = "LKR"
    case DZD = "DZD"
    case RSD = "RSD"
    case CRC = "CRC"
    case TOP = "TOP"
    case CLF = "CLF"
    case ILS = "ILS"
    case GGP = "GGP"
    case PKR = "PKR"
    case ARS = "ARS"
    case KHR = "KHR"
    case AUX = "AUX"
    case SOS = "SOS"
    case GYD = "GYD"
    case ANG = "ANG"
    case BAM = "BAM"
    case LTL = "LTL"
    case KGS = "KGS"
    case PEN = "PEN"
    case SBD = "SBD"
    case NZD = "NZD"
    case GNF = "GNF"
    case MNT = "MNT"
    case VND = "VND"
    case AZN = "AZN"
    case BTN = "BTN"
    case ALL = "ALL"
    case VUV = "VUV"
    case ZAR = "ZAR"
    case NIO = "NIO"
    case XOF = "XOF"
    case DOP = "DOP"
//    case 9NY = "9NY"
    case XAF = "XAF"
//    case 1OZ = "1OZ"
    case JOD = "JOD"
    case XAG = "XAG"
    case MGA = "MGA"
    case IDR = "IDR"
    case CLP = "CLP"
    case GEL = "GEL"
    case UAH = "UAH"
    case HUF = "HUF"
    case ADE = "ADE"
    case THB = "THB"
    case MDL = "MDL"
    case BYR = "BYR"
    case ETB = "ETB"
    case DEM = "DEM"
    case OGE = "OGE"
    case SAR = "SAR"
    case MRU = "MRU"
    case QAR = "QAR"
    case EUR = "EUR"
    case JMD = "JMD"
    case PYG = "PYG"
    case IQD = "IQD"
    case BMD = "BMD"
    case GTQ = "GTQ"
    case XPD = "XPD"
    case KWD = "KWD"
    case PGK = "PGK"
    case MAD = "MAD"
    case ZWL = "ZWL"
    case BZD = "BZD"
    case KMF = "KMF"
    case OMR = "OMR"
    case TMT = "TMT"
    case XPF = "XPF"
    case MMK = "MMK"
    case ERN = "ERN"
    case TND = "TND"
    case BIF = "BIF"
    case BHD = "BHD"
    case TWD = "TWD"
    case HKD = "HKD"
    case COP = "COP"
    case GHS = "GHS"
    case RUB = "RUB"
    case MKD = "MKD"
    case INR = "INR"
    case NPR = "NPR"
    case VES = "VES"
    case UGX = "UGX"
//    case 999 = "999"
    case JPY = "JPY"
    case BSD = "BSD"
    case BRL = "BRL"
    case MUR = "MUR"
    case HTG = "HTG"
}
