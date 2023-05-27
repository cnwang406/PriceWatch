//
//  InputMoneyView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/27.
//

import SwiftUI

struct InputMoneyView: View {
    //MARK: - PROPERTIES
    @State var moneyEnteredStr: String = "1.0"
    @Binding var money : Double
    @Binding var showInputView:Bool
    private var numberFormatter: NumberFormatter{
        let nf = NumberFormatter()
//        numberFormatter = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 2
        return nf
      }
  //MARK:
    
        
    
    var body: some View {
        VStack{
            
            TextField(moneyEnteredStr, value: $money, formatter: numberFormatter)
                .multilineTextAlignment(.trailing)
                .font(.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(.yellow)
                .padding(40)
                .keyboardType(.decimalPad)
            
            Button("OK") {
                
                showInputView = false
            }
        }
    }
}


//MARK: - PREVIEW
//struct InputMoneyView_Previews: PreviewProvider {
//    @State var money: Double = 100.0
//    static var previews: some View {
//        InputMoneyView(money: .Const() )
//    }
//}
