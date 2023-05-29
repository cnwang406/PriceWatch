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
                .keyboardType(.default)
                .submitLabel(.continue)
                .onSubmit {
                    print ("TextField data = \(money)")
                }
                .padding(40)

            Button("OK") {
                showInputView = false
            }
            .font(.title)
                .overlay {
                    RoundedRectangle(cornerRadius: 12.0)
                        .stroke(style: StrokeStyle(lineWidth: 3.0))
                        .foregroundColor(.blue)
                        .frame(width: 140, height:60)
                }
            Spacer()
        }
    }
}


//MARK: - PREVIEW
struct InputMoneyView_Previews: PreviewProvider {
    @State static  var money: Double = 100.0
    static var previews: some View {
        InputMoneyView(money: $money, showInputView: .constant(false))
    }
}
