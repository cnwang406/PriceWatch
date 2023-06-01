//
//  ContentView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/16.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
   
        TabView(){
            
            RealTimeCurrencyView()
                .tabItem {
                      Image(systemName: "arrow.up")
                        Text("RealTime")
                }
            DailyCurrencyView()
                .tabItem{
                    Image(systemName: "clock")
                    Text("Daily")}
            AlarmView()
                .tabItem {
                    Image(systemName: "alarm")
                    Text("Alarm")
                }
            ProgressView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
        
            
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
