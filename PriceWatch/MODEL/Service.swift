////
////  Service.swift
////  PriceWatch
////
////  Created by Chun nan Wang on 2023/5/17.
////
//
//import SwiftUI
//
//class Service: ObservableObject {
//    
//    static var shared = Service()
//    var loading: Bool = false
//    var urlHead: String = "https://www.goodstock.com.tw/stock_quote.php?stockname="
//    var stock_: String = "%E8%81%AF%E7%A9%8E%E5%85%89%E9%9B%BB"
//    // https://www.goodstock.com.tw/stock_quote.php?stockname=%E8%81%AF%E7%A9%8E%E5%85%89%E9%9B%BB
//    
//    var stock: String = UserDefaults(suiteName: groupIdentifier)?.string(forKey: "stock") ?? "聯穎光電"
//    //    var lll: String = "https%3A%2F%2Fwww.goodstock.com.tw%2Fstock_quote.php%3Fstockname%3D"
//    var cssTextString : String = "tr"
//    
//    var data: [CurrencyElement] = []
//    
//    var validStock: Bool = true
//    // item founds
//    
//    
//    func reload() async {
//        let url = URL(string: "https://openapi.taifex.com.tw/v1/DailyForeignExchangeRates")!
//        let urlSession = URLSession.shared
//        do {
//            let (data, response) = try! await urlSession.data(from: url)
//            self.data = try JSONDecoder().decode([CurrencyElement].self, from: data)
//        } catch {
//            print ("Error loading ")
//        }
//        
//    }
//    
//    
//    
//    
//    
//}
