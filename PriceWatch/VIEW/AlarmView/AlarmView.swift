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
    @State var showInputView:Bool = false
    @State var modifyIdx: Int = 0
    //MARK: - VIEW
    var body: some View {
        List{
            ForEach(vm.alarmList.indices, id:\.self) { idx in
                let each = vm.alarmList[idx]
                AlarmItemView(item: each)
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            print("edit alarm")
                            modifyIdx = idx
                            print ("before edit")
                            print (vm.alarmList[modifyIdx])
                            showInputView.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.indigo)
                        
                        Button(role: .destructive) {
                            print("Deleting conversation")
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                
            }
            .onMove { IndexSet, Int in
                print ("move \(IndexSet), \(Int)")
            }
            
            
            .sheet(isPresented: $showInputView) {
                print ("dismiss")
                print (vm.alarmList[modifyIdx])
            } content: {
                
                AlarmEditView(am: $vm.alarmList[modifyIdx]  ,showInputView: $showInputView)
                
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
