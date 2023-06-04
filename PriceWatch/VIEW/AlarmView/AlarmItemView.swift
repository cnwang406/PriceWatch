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
            Gauge(value: (item.rate - item.low) / (item.high - item.low)) {
                Text(item.dollar.rawValue)
                    
            } currentValueLabel: {

                Text("\(item.rate.myFormat(digit: 4))")
               
                    .foregroundColor(statusColor(status: status))
                    .font(.caption)
            } minimumValueLabel: {
                Text("\(item.low.myFormat(digit: 3))")
                    .font(.system(size: 6.0))
            } maximumValueLabel: {
                Text("\(item.high.myFormat(digit: 3))")
                    .font(.system(size: 6.0))
            } markedValueLabels: {
                Text("haaa")
            }
//            .tint(statusColor(status: status))
            .tint(alarmGaugeGradient)
            .gaugeStyle(.accessoryCircular)
//            .background(.pink)
            .scaleEffect(2)
            .animation(.easeIn(duration: 2.5), value: drawDot)
            .frame(width: 160)
            
        }
        .frame(height:160)
        .onAppear {
            
                (self.rate, self.status) = ratePosition(item: self.item)
            
            drawDot.toggle()
            
            
        }
    }
    
//    func roundTo(number : Double, digit: Int) -> Double {
//        
//        
//        var r =  (pow(10, digit - (String(Int(number)).count))) as NSNumber
//        var k: Double = 0
//        if number < 1 {
//              k = Double (truncating: r) * 10
//        } else {
//            k = Double(truncating: r)
//        }
//        return  1 / k
//    }
    
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
