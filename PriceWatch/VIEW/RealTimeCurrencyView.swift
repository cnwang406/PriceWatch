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
    
    @State private var scaleFactor: Double = 1.0
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
                    

                HStack{
                    Image(vm.basedDollar?.rawValue ?? "TWD")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.trailing,20)
                    Text("1 \(vm.basedDollar?.rawValue ?? "TWD") = ?foriegn dollars ")
                }
                List (vm.currency) { cur in
                    RTCurrencyItemView(cur: cur, editable: false)
                    .padding(.horizontal,3)
                    .multilineTextAlignment(.leading)
                    .scaleEffect(cur.isBaseDollar ? 1.1 : 1.0)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 0.95, damping: 1.5, initialVelocity: 1), value: scaleFactor)
                    .onTapGesture {
                        if vm.basedDollar == cur.name {
                            print ("Edit")
                            self.showInputView.toggle()
                        } else {
                            print ("basedollar to \(cur.name.rawValue)")
                            vm.setBaseDollar(cur.name)
                            scaleFactor = cur.isBaseDollar ? 1.1 : 1.0
                            vm.baseRate = cur.rate
                            vm.edit(CheckCurrency: cur)
                            print ("scaleEffect : \(scaleFactor) for \(cur.name.rawValue)")
                        }
                    }
                    .onSubmit {
                        print ("CurrecnyView submit \(cur.rate)")
                        
                        
                    }
                    
                }
    
                
                
                Spacer()
                Text("Latest update \(Date(timeIntervalSince1970: vm.dm.latestUpdate))")
                    .font(.footnote).opacity(0.3)
                    
                    .navigationTitle(Text("RealTime Xchg(\(vm.dm.rtCurrencies.count))"))

                    .onTapGesture {
                        vm.dump()
                    }
            }
            
            
        }
        .sheet(isPresented: $showInputView, onDismiss: {
            print ("new value : \(moneyInput) for \(vm.basedDollar?.rawValue ?? "")")
            vm.baseMoney = moneyInput
            vm.calculate()
        }, content: {
            InputMoneyView(money: $moneyInput, showInputView: $showInputView)
                .presentationDetents([.medium,.fraction(0.3)])
//                .presentationDragIndicator(.hidden)
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
