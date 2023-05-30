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
                    Text("RealTime")
                }
            DailyCurrencyView()
                .tabItem{
                    Text("Daily")}
        }
        
            
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
