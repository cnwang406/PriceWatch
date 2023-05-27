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
    @State var showInputView:Bool = false
    @State var moneyInput: Double = 1.0
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
                    

                Text("1 foriegn dollars = ? \(vm.basedDollar.rawValue)")
                List (vm.currency) { cur in
                    RTCurrencyItemView(cur: cur, editable: false)
                    .padding(.horizontal,3)
                    .multilineTextAlignment(.leading)
                    .onTapGesture {
                        if vm.basedDollar == cur.name {
                            print ("Edit")
                            self.showInputView.toggle()
                        } else {
                            print ("basedollar to \(cur.name.rawValue)")
                            vm.edit(CheckCurrency: cur)
                        }
                    }
                    .onSubmit {
                        print ("CurrecnyView submit \(cur.rate)")
                        
                    }
                    
                }
                
                
                Spacer()
                Text("Latest update \(Date(timeIntervalSince1970: vm.dm.latestUpdate))")
                    .navigationTitle(Text("RealTime Xchg(\(vm.dm.rtCurrencies.count))"))
                    .onTapGesture {
                        vm.dump()
                    }
            }
            
            
        }
        .sheet(isPresented: $showInputView, onDismiss: {
            print ("new value : \(moneyInput)")
            vm.dm.baseMoney = moneyInput
            print ("vm.dm.baseMoney = \(vm.dm.baseMoney)")
            vm.dm.parse()
        }, content: {
            
            InputMoneyView(money: $moneyInput, showInputView: $showInputView)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
        })
            
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
