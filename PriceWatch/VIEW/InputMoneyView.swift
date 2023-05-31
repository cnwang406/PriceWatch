//
//  InputMoneyView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/27.
//

import SwiftUI

struct InputMoneyView: View {
    //MARK: - PROPERTIES
    @StateObject var dm = CurrencyModel.share
    @State var moneyEnteredStr: String = "1.0"
    @Binding var money : Double
    @State var moneyS: String = "1.0"
    @Binding var showInputView:Bool
    
    
    private var numberFormatter: NumberFormatter{
        let nf = NumberFormatter()
//        numberFormatter = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 2
        return nf
      }
  //MARK:
    
    enum FocusedField {
        case dec
    }
    @FocusState var focusedField : FocusedField?
    
    var body: some View {
        VStack{
            HStack{
                
                Text("Input $$ in \(dm.baseDollar.rawValue)")
                Image(dm.baseDollar.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .padding(.trailing,20)
                    
            }
                .font(.title)
                .foregroundColor(.primary)
                .padding()
//            TextField(moneyEnteredStr, value: $money, formatter: numberFormatter)
            TextField(moneyEnteredStr, text: $moneyS)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 50))
                .fontWeight(.bold)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedField, equals: .dec)
                .keyboardType(.decimalPad)
                .onTapGesture {
                    moneyS="1"
                    money=1.0
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20.0)
                        .stroke(style: StrokeStyle(lineWidth: 3.0))
                        .foregroundColor(.blue)
                        
                }
                .numbersOnly($moneyS, includeDecimal: true)
                .padding(.horizontal,20)
                .padding(40)

            Button("OK") {
                showInputView = false
                money = Double(moneyS) ?? 1.0
                playFeedbackHaptic(.heavy)
                
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(style: StrokeStyle(lineWidth: 3.0))
                    .foregroundColor(.blue)
                    .frame(width: 140, height:60)
            }
            .font(.title)
            
            
                
            Spacer()
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Spacer()
                    }
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            focusedField = nil
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
        }
        .onAppear{
            UITextField.appearance().clearButtonMode = .whileEditing
            moneyS = String(money)
            print ("InputMoneyView Start, moneyS =\(moneyS), money = \(money)")
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
