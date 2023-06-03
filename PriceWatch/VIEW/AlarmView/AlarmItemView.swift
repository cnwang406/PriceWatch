//
//  AlarmItemView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/1.
//

import SwiftUI

enum AlarmStatus {
    case tooLow
    case lowerThenBuy
    case higherThenBuy
    case tooHigh
}
struct AlarmItemView: View {
    //MARK: - PROPERTIES
    var item: AlarmModel
    @State var rate: Double = 0.0
    @State var status: AlarmStatus = .tooLow
    @State var drawDot:Bool = false
    
    //MARK: - VIEW
    var body: some View {
        HStack{
            Text(item.dollar.rawValue)
            Image(item.dollar.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
            Gauge(value: rate) {
                Text(item.dollar.rawValue)
                    
            } currentValueLabel: {
                Text("\(item.rate.formatted())")
                    .foregroundColor(statusColor(status: status))
                    .font(.caption)
            } minimumValueLabel: {
                Text("\(item.low.formatted())")
                    .font(.system(size: 8.0))
            } maximumValueLabel: {
                Text("\(item.high.formatted(.number))")
                    .font(.system(size: 8.0))
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
            
        }
        .frame(height:160)
        .onAppear {
            
                (self.rate, self.status) = ratePosition(item: self.item)
            drawDot.toggle()
            
        }
    }
    
    
}


//MARK: - PREVIEW
struct AlarmItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            
            AlarmItemView(item: demoAlarmModel)
            AlarmItemView(item: demoAlarmModelL)
            AlarmItemView(item: demoAlarmModelLL)
            AlarmItemView(item: demoAlarmModelH)
            AlarmItemView(item: demoAlarmModelHH)
        }
    }
}
