//
//  AlarmView.swift
//  PriceWatch
//
//  Created by Chun nan Wang on 2023/6/1.
//

import SwiftUI

struct AlarmView: View {
    //MARK: - PROPERTIES
    
    @StateObject var vm = AlarmViewModel()
    //MARK: - VIEW
    var body: some View {
        List{
            ForEach(vm.alarmList, id:\.self) { each in
                AlarmItemView(item: each)
                
            }
            .onDelete { IndexSet in
                print ("delete \(IndexSet)")
            }
            .onMove { IndexSet, Int in
                print ("move \(IndexSet), \(Int)")
            }
            
        }
        .onAppear{
            vm.loadAlarms()
            
        }
    }
}


//MARK: - PREVIEW
struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
