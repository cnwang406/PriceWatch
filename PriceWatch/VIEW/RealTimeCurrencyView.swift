//
//  RealTimeCurrencyView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/18.
//

import SwiftUI

struct RealTimeCurrencyView: View {
    //MARK: - PROPERTIES
    @StateObject var vm = RealTimeCurrencyViewModel()
    var  currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
    
    static let numberFormat: NumberFormatter =  {
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .none
           numberFormatter.positivePrefix = "+"
           numberFormatter.negativePrefix = "-"
           return numberFormatter
       }()

    //MARK: - VIEW
    var body: some View {
        ZStack{
            if vm.dm.loading {
                VStack{
                        Text("Loading")
                    ProgressView()
                        .scaleEffect(3.0)
                }
            }
            NavigationStack{
                    
//                List{
//
//                    Text("USD to TWD")
//                    HStack{
//                        Text("USD \(vm.dm.rtCurrencies["USDTWD"]?.exrate ?? -99.99)")
//                        Text("\(vm.currencies["USDTWD"]?.utc ?? "--")")
//                    }
//                    HStack{
//                        Text("JPY \(vm.dm.rtCurrencies["JPYTWD"]?.exrate ?? -99.99)")
//                        Text("\(vm.currencies["USDTWD"]?.utc ?? "--")")
//                    }
//                    Text("USD \(vm.dm.rtCurrencies["JPYTWD"]?.exrate ?? -99.99)")
//                    Text("\(vm.self.latestDataTime)")
//
//                }
                Text("1 foriegn dollars = ? NTD")
                List (vm.currency) { cur in
                    RTCurrencyItemView(cur: cur, editable: false)
//                    HStack(alignment: .center){
//                        Text("\(cur.name.rawValue)")
//                            .multilineTextAlignment(.leading)
//                            .frame(width:40)
//                            
//                        Spacer()
//                            .frame(width: 20)
//                            
//                        Text("\(Double(1.0).formatted(.currency(code: cur.name.rawValue).rounded(rule: .awayFromZero, increment: 1))) = \(cur.rate.formatted(.currency(code: "TWD").rounded(rule: .awayFromZero, increment: 0.001)))")
//                            .multilineTextAlignment(.leading)
//                        Spacer()
//                        Text("\(Date(timeIntervalSince1970: cur.timestamp).formatted(.dateTime.locale(Locale(identifier: "US"))))")
//                            .font(.footnote)
//                            .fontWeight(.light)
//                            .opacity(0.3)
//                            .frame(width: 70)
//                            
//                    }
                    .padding(.horizontal,3)
                    .multilineTextAlignment(.leading)
                    
                }
                
                
                Spacer()
                Text("Latest update \(Date(timeIntervalSince1970: vm.dm.latestUpdate))")
                    .navigationTitle(Text("RealTime Xchg(\(vm.dm.rtCurrencies.count))"))
            }
            
            
        }
            
        .padding()
        .task {
            await vm.reload()
        }
        .refreshable {
            await vm.reload()
        }
    }
}


//MARK: - PREVIEW
struct RealTimeCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        RealTimeCurrencyView()
    }
}
