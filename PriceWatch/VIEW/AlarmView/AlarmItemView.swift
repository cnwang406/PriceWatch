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
    let gradient = Gradient(colors: [.red, .orange, .blue, .green])
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
            } minimumValueLabel: {
                Text("\(item.low.formatted())")
            } maximumValueLabel: {
                Text("\(item.high.formatted(.number))")
            } markedValueLabels: {
                Text("haaa")
            }
//            .tint(statusColor(status: status))
            .tint(gradient)
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
    
    func ratePosition(item: AlarmModel) -> (Double, AlarmStatus) {
        
        let width = item.high * 1.1 - item.low * 0.9
        let ratio = (item.rate - item.low * 0.9) / width
        var status: AlarmStatus = .tooLow
        if item.rate < item.low {
            status = .tooLow
        } else if item.rate <= item.buy {
            status = .lowerThenBuy
        } else if item.rate < item.high {
            status = .higherThenBuy
        } else {
            status = .tooHigh
        }
            
        return (ratio, status)
        
    }
    
    func statusColor(status: AlarmStatus) -> Color {
        switch status {
        case .tooHigh:
            return .green
        case .higherThenBuy:
            return .blue
        case .lowerThenBuy:
            return .orange
        case .tooLow:
            return .red
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
