//
//  AlarmEditView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/2.
//

import SwiftUI

@MainActor
struct AlarmEditView: View {
    //MARK: - PROPERTIES
    @Binding var am: AlarmModel
    @Binding var showInputView: Bool
    var modifyMode: Bool = true
    @State var editAm: AlarmModel = demoAlarmModelH
    @State var status: AlarmStatus = .tooLow
    @State var drawDot:Bool = false
    @State var selectDollar: Dollars = .TWD
//    var watchList: [Dollars] = []
    var watchList: Set<String> = []
    var vm = AlarmViewModel.share
    var dm = CurrencyModel.share
    //MARK: - VIEW
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20){
                    Picker("Dollars", selection: $selectDollar) {

                        ForEach(Dollars.allCases, id:\.self) { dollar in
                            if !watchList.contains(dollar.rawValue) {
                                Text("\(dollar.rawValue)")
                            }
                        }
                        
                    }
                    .onChange(of: selectDollar, perform: { newValue in
                        print ("Picker onChange")
                        editAm.dollar = selectDollar
                        editAm.rate = dm.getXRate(dollar: selectDollar)
                        editAm.low = editAm.rate * 0.9
                        editAm.high = editAm.rate * 1.1
                        editAm.buy = editAm.rate
                    })
                    .onAppear{
                        print ("Picker onAppear")
                        editAm.dollar = selectDollar
                        editAm.rate = dm.getXRate(dollar: selectDollar)
                        editAm.low = editAm.rate * 0.9
                        editAm.high = editAm.rate * 1.1
                        editAm.buy = editAm.rate
                    }
                    .disabled(modifyMode)
                    .opacity(modifyMode ? 0 : 1.0)

                    .padding(.bottom,0)
                    
                    
                    Gauge(value: (editAm.rate - editAm.low) / (editAm.high - editAm.low)) {
                        Text(editAm.dollar.rawValue)
                    } currentValueLabel: {
                        Text("\(editAm.rate.formatted(.number.rounded(rule: .awayFromZero, increment: 0.1)))")
                            .foregroundColor(statusColor(status: status))
                    } minimumValueLabel: {
                        Text("\(editAm.low.formatted(.number.rounded(rule: .awayFromZero, increment: 0.1)))")
                            .font(.system(size: 6))
                    } maximumValueLabel: {
                        Text("\(editAm.high.formatted(.number.rounded(rule: .awayFromZero, increment: 0.1)))")
                            .font(.system(size: 6))
                    } markedValueLabels: {
                        Text("haaa")
                    }
                    //            .tint(statusColor(status: status))
                    .tint(alarmGaugeGradient)
                    .gaugeStyle(.accessoryCircular)
                    //            .background(.pink)
                    .scaleEffect(3)
                    .animation(.easeIn(duration: 2.0), value: drawDot)
                    .frame(width: 160)
                    .padding(.top, 90)
                    .padding(.bottom, 30)
                    
                    Text("\(editAm.dollar.rawValue)")
                        .font(.title2)
                    
                    
                    HStack{
                        
                        Text("Low = \(editAm.low.myFormat(digit: 3))")
                            .font(.title2)
                        Slider(value: $editAm.low, in: (0...am.high))
                            .frame(width: 250)
                    }
                    HStack{
                        
                        Text("High = \(editAm.high.myFormat(digit: 3))")
                            .font(.title2)
                        Slider(value: $editAm.high, in: (am.low...100))
                            .frame(width: 250)
                    }
                    HStack{
                        Text("Buy = \(editAm.buy.myFormat(digit: 3))")
                            .font(.title2)
                        Slider(value: $editAm.buy, in: (am.low...am.high))
                            .frame(width: 250)
                        
                    }
                    Text("Alarm Now = \(editAm.rate.formatted())")
                        .font(.title2)
                    
                    
                    
                    Spacer()
                    Button("OK") {
                        showInputView = false
                        am = editAm
                        print ("ok in AlarmEditView")
                        print (" editAm = \(editAm)")
                        print (" am = \(am)")
                        playFeedbackHaptic(.heavy)
                        
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(style: StrokeStyle(lineWidth: 3.0))
                            .foregroundColor(.blue)
                            .frame(width: 140, height:60)
                    }
                    .font(.title)
                    
                }
                .padding(.horizontal,20)
                
                .navigationTitle(modifyMode ? "Edit Alarm" : "Add Alarm")
                .onAppear{
                    print ("AlarmEditView appear")

                    if modifyMode {
                        editAm = am
                        selectDollar = am.dollar
                    } else { // new. empty one
                        let rate = dm.getXRate(dollar: .TWD)
                        editAm = AlarmModel( dollar: .TWD, low: rate * 0.9, high: rate * 1.1, rate: rate, buy: rate, activate: true)
                        var dollarSet : Set<String> = []
                        for dollar in Dollars.allCases {
                            dollarSet.insert(dollar.rawValue)
                        }
                        var remainDollar = dollarSet.subtracting(watchList)
                        if remainDollar.count == 0 {
                            am.rate = -1.0
                            showInputView = false
                        } else {
                            selectDollar = str2Dollar(fromStr: remainDollar.first!) ?? .TWD
                        }
                        am.rate = -1.0
                        
                    }
//                    selectDollar = .GBP
                    
            }
            }
        }
        
        
    }
    
}


//MARK: - PREVIEW
struct AlarmEditView_Previews: PreviewProvider {
    @State static var am: AlarmModel = demoAlarmModelH
    static var previews: some View {
        Group{
            AlarmEditView(am: $am, showInputView: .constant(true), modifyMode: true)
            AlarmEditView(am: $am, showInputView: .constant(true), modifyMode: false)
        }
    }
}
