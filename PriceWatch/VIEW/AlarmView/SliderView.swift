//
//  SliderView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/3.
//

import SwiftUI

struct SliderView: View {
    //MARK: - PROPERTIES
    @Binding var value: Double
    @State var slider : Double = 0.5
    var lcl: Double
    var hcl : Double
    @State var lastMove : Double = Date().timeIntervalSince1970 * 1000
    //MARK: - VIEW
    var body: some View {
        VStack{
            
            Text("\(value.formatted())")
            Slider(value: $slider) {
                Text("go")
            } minimumValueLabel: {
                Text("Min")
            } maximumValueLabel: {
                Text("Max")
            }
//            .onChange(of: slider) { newValue in
//                if Date().timeIntervalSince1970 * 1000 - lastMove > 500 {
//                    
//                    
//                    print (newValue)
//                    if newValue > 0.8 {
//                        value += (hcl - lcl) / 10
//                        value = value > hcl ? hcl : value
//                        slider = 0.5
//                    }else if newValue > 0.5 {
//                        value += (hcl - lcl) / 40
//                        value = value > hcl ? hcl : value
//                        slider = 0.5
//                    } else if (newValue > 0.2) && (slider < 0.5) {
//                        value -= (hcl - lcl) / 40
//                        value = value < lcl ? lcl : value
//                        slider = 0.5
//                    } else if (newValue < 0.2){
//                        value -= (hcl - lcl) / 10
//                        value = value < lcl ? lcl : value
//                        slider = 0.5
//                    }
//                    lastMove = Date().timeIntervalSince1970 * 1000
//                }
//            }
        }

    }
}


//MARK: - PREVIEW
struct SliderView_Previews: PreviewProvider {
    
    static var previews: some View {
        SliderView(value: .constant(29.0), lcl: 27.0, hcl: 31.0)
    }
}
