//
//  DailyCurrencyView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/5/18.
//

import SwiftUI

struct DailyCurrencyView: View {
    
    @StateObject var vm = DailyCurrencyViewModel()
    var body: some View {
        
        ZStack{
            if vm.loading {
                VStack{
                    Text("Loading")
                    ProgressView()
                        .scaleEffect(3.0)
                }
            }
            NavigationStack{
                
                List(vm.currencies){data in
                    HStack{
                        Text(data.date)
                        Text(data.usdNtd)
                    }
                    
                }
                Spacer()
                Text("Latest update \(Date(timeIntervalSince1970: vm.dm.latestUpdate))")
                
                    .navigationTitle(Text("Currency"))
            }
        }
        
        .padding()
        .task {
            await vm.reload()
        }
        .refreshable {
            await vm.reload()
        }
        
    }
}


//MARK: - PREVIEW
struct DailyCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyCurrencyView()
    }
}
