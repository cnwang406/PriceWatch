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
                .foregroundColor(cur.baseDollar ? .blue : .primary)
                .frame(width:40)
                
//            Spacer()
//                .frame(width: 20)
            Image(cur.name.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .padding(.trailing,20)

                
                Text(" \(cur.money.formatted(.currency(code: "TWD").rounded(rule: .awayFromZero, increment: 0.001)))")
                    .foregroundColor(editable ? .green : (cur.vaildate ? .primary : .gray.opacity(0.5)))
                
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing,20)
            
                
            Text("\(Date(timeIntervalSince1970: cur.timestamp).formatted(.dateTime.locale(Locale(identifier: "US"))))")
                .font(.system(size: 8))
                .fontWeight(.light)
                .opacity(0.3)
                .frame(width: 45)
                
        }
        .onAppear(){
//            cur.money = cur.rate
            self.enteredMoney = cur.rate
            self.enteredMoneyStr = String(self.enteredMoney)
        }
    }
    
}


//MARK: - PREVIEW
struct RTCurrencyItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox{
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "USD")!, rate: 30.0, vaildate: true),editable: true)
                .padding()
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "USD")!, rate: 30.0, vaildate: true),editable: false)
                .padding()
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "USD")!, rate: 30.0, vaildate: false),editable: false)
                .padding()
            RTCurrencyItemView(cur: MyCurrencyModel(timestamp: Date().timeIntervalSince1970, name: Dollars(rawValue: "TWD")!, rate: 30.0, vaildate: true, baseDollar: true),editable: false)
                .padding()
        }
    }
}
