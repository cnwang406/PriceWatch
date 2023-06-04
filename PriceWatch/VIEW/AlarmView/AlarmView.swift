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
    @State var myEditAm : AlarmModel = demoAlarmModel
    //MARK: - VIEW
    var body: some View {
        
        
        NavigationView {
            List{
                ForEach(vm.alarmList.indices, id:\.self) { idx in
                    let each = vm.alarmList[idx]
                    AlarmItemView(item: each)
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                print("edit alarm \(vm.alarmList[idx].dollar.rawValue) ")
                                myEditAm = each
                                modifyIdx = idx
                                print ("before edit")
                                print (vm.alarmList[idx])
                                showInputView.toggle()
                            } label: {
                                Label("Edit\(vm.alarmList[idx].dollar.rawValue)\(idx)", systemImage: "pencil")
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
                    print ("vm.alarmList[\(modifyIdx)] = \(vm.alarmList[modifyIdx])")
                    print ("myEditAm = \(myEditAm)")
                    vm.alarmList[modifyIdx] = myEditAm
                    print ("after assign, vm.alarmList[\(modifyIdx)] = \(vm.alarmList[modifyIdx])")
                    vm.save()
                } content: {
                    
//                    AlarmEditView(am: $vm.alarmList[modifyIdx]  ,showInputView: $showInputView)
                    AlarmEditView(am: $myEditAm  ,showInputView: $showInputView)
                    
                }
                
            }
            .onAppear{
                vm.loadAlarms()
                
            }
            .navigationTitle(Text("Alarm View N"))
        }
        
    }
}


//MARK: - PREVIEW
struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
