//
//  AlarmEditView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/2.
//

import SwiftUI

struct AlarmEditView: View {
    //MARK: - PROPERTIES
    @Binding var am: AlarmModel
    @Binding var showInputView: Bool
    @State var editAm: AlarmModel = demoAlarmModelH
    @State var status: AlarmStatus = .tooLow
    @State var drawDot:Bool = false
    
    //MARK: - VIEW
    var body: some View {
        NavigationView {
            VStack(spacing: 30){
                Gauge(value: (am.rate - am.low) / (am.high - am.low)) {
                    Text(am.dollar.rawValue)
                } currentValueLabel: {
                    Text("\(am.rate.formatted(.number.rounded(rule: .awayFromZero, increment: 0.1)))")
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
                .scaleEffect(4)
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
            
            .navigationTitle("Edit Alarm")
            .onAppear{
                print ("AlarmEditView appear")
                editAm = am
                
        }
        }
        
        
    }
    
}


//MARK: - PREVIEW
struct AlarmEditView_Previews: PreviewProvider {
    @State static var am: AlarmModel = demoAlarmModelH
    static var previews: some View {
        AlarmEditView(am: $am, showInputView: .constant(true))
    }
}
