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
            
            DailyCurrencyView()
                .tabItem{
                    Text("Daily")}
            RealTimeCurrencyView()
                .tabItem {
                    Text("RealTime")
                }
        }
        
            
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}