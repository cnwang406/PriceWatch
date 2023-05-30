//
//  RTCurrencyItemView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/25.
//

import SwiftUI

struct RTCurrencyItemView: View {
    //MARK: - PROPERTIES
//    var baseMoney: Double
    var cur: MyCurrencyModel
    var editable: Bool
    @State var enteredMoney: Double = 0.0
    @State var enteredMoneyStr: String = "1.0"
    
    
    //MARK: - VIEW
    var body: some View {
        HStack(alignment: .center){
            Text("\(cur.name.rawValue)")
                .multilineTextAlignment(.leading)
                .foregroundColor(cur.isBaseDollar ? .blue : .primary)
                .frame(width:40)
             
            Image(cur.name.rawValue)
                .resizable()
                .scaledToFit()
//                .scaleEffect(cur.isBaseDollar ? 1.1 : 1.0)
//                .animation(.interpolatingSpring(mass: 1, stiffness: 1, damping: 0.5, initialVelocity: 10), value: scaleFactor)
                .frame(width: 30)
                .padding(.trailing,20)
                .opacity(cur.isBaseDollar ? 1.0 : 0.7)

            Spacer()
            Text(" \(cur.money.formatted(.currency(code: cur.name.rawValue).rounded(rule: .awayFromZero, increment: 0.01)))")
                    .foregroundColor(editable ? .green : (cur.vaildate ? .primary : .gray.opacity(0.5)))
                    .font(.title)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing,20)

                
        }
        .padding(.vertical,20)
        .onAppear(){
            
            self.enteredMoney = cur.rate
            self.enteredMoneyStr = String(self.enteredMoney)
            
        }
    }
    
}


//MARK: - PREVIEW
struct RTCurrencyItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox{
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "USD")!, rate: 30.0, vaildate: true, isBaseDollar: false),editable: true)
                .padding()
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "USD")!, rate: 30.0, vaildate: true, isBaseDollar: false),editable: false)
                .padding()
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "USD")!, rate: 30.0, vaildate: false, isBaseDollar: false),editable: false)
                .padding()
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "TWD")!, rate: 30.0, vaildate: true, isBaseDollar: true),editable: false)
                .padding()
        }
    }
}
