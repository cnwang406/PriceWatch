//
//  ContentView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/16.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var service = Service.shared
    @ObservedObject var dm = CurrencyModel()
    var body: some View {
        
        ZStack{
            if dm.loading {
                VStack{
                        Text("Loading")
                    ProgressView()
                        .scaleEffect(3.0)
                }
            }
            NavigationStack{
                    
                List(dm.currencies){data in
                    HStack{
                        Text(data.date)
                        Text(data.usdNtd)
                        
                    }
                    
                }
                Spacer()
                    .navigationTitle(Text("Currency"))
            }
            
            
        }
            
        
        .padding()
        .task {
            await dm.reload()
        }
        .refreshable {
            await dm.reload()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
