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
        VStack(spacing: 30){
            Text("Edit Alarm")
                .font(.title)
            Spacer()
            Gauge(value: am.rate) {
                Text(am.dollar.rawValue)
            } currentValueLabel: {
                Text("\(am.rate.formatted())")
                    .foregroundColor(statusColor(status: status))
            } minimumValueLabel: {
                Text("\(am.low.formatted())")
            } maximumValueLabel: {
                Text("\(am.high.formatted(.number))")
            } markedValueLabels: {
                Text("haaa")
            }
//            .tint(statusColor(status: status))
            .tint(alarmGaugeGradient)
            .gaugeStyle(.accessoryCircular)
//            .background(.pink)
            .scaleEffect(2)
            .animation(.easeIn(duration: 2.0), value: drawDot)
            .frame(width: 160)
            .padding(.bottom, 30)
            Text("\(editAm.dollar.rawValue)")
                .font(.title2)
            Text("Alarm Low = \(editAm.low.formatted())")
                .font(.title2)
            Text("Alarm High = \(editAm.high.formatted())")
                .font(.title2)
            Text("Alarm Buy = \(editAm.buy.formatted())")
                .font(.title2)
            Text("Alarm Now = \(editAm.rate.formatted())")
                .font(.title2)
            Spacer()
            Button("OK") {
                showInputView = false
                am = editAm
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
        
            
            .onAppear{
                editAm = am
                
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
