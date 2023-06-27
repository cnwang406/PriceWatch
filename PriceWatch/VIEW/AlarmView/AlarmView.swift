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
    @State var showAddView:Bool = false
    @State var modifyIdx: Int = 0
    @State var myEditAm : AlarmModel = demoAlarmModel
    //MARK: - VIEW
    var body: some View {
        
        
        NavigationStack {
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
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.indigo)
                            
                            Button(role: .destructive) {
                                print("Delete \(each)")
                                
                                vm.delAlarm(each)
                                
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    
                    
                } // ForEach
                .onMove { IndexSet, Int in
                    print ("move \(IndexSet), \(Int)")
                }
                
            }
            
            .sheet(isPresented: $showInputView) {
                print ("dismiss from edit")
                print ("vm.alarmList[\(modifyIdx)] = \(vm.alarmList[modifyIdx])")
                print ("myEditAm = \(myEditAm)")
                vm.alarmList[modifyIdx] = myEditAm
                print ("after assign, vm.alarmList[\(modifyIdx)] = \(vm.alarmList[modifyIdx])")
                vm.save()
            } content: {
                
                //                    AlarmEditView(am: $vm.alarmList[modifyIdx]  ,showInputView: $showInputView)
                AlarmEditView(am: $myEditAm  ,showInputView: $showInputView, modifyMode: true)
                
            }
            .sheet(isPresented: $showAddView) {
                print ("dismiss from add")
                print ("add new alarm")
                print ("myEditAm = \(myEditAm)")
                if myEditAm.rate > 0 {
                    vm.addAlarm(myEditAm)
                }
            } content: {
                AlarmEditView(am: $myEditAm  ,showInputView: $showAddView,modifyMode: false, watchList: vm.alarmSet)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button {
                        vm.checkAlarmList()
                    } label: {
                        Image(systemName: vm.dm.loading ? "eye" : "eye.fill")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        if vm.nonAlarmSet.count > 0 {
                            showAddView = true
                            print ("add, \(showAddView)")
                        }
                        
                    } label: {
                        Image(systemName: "plus.circle")
                            .disabled(vm.nonAlarmSet.count == 0)
                    }
                }
                
                
            }
            .onAppear{
                
                vm.loadAlarms()
                print ("AlarmViewModel after loadAlarms, watchList = \(vm.alarmSet)")
                vm.checkAlarmList()
            }
            .refreshable {
                print ("AlarmViewModel refreshed watchList = \(vm.alarmSet)")
                vm.loadAlarms()
                vm.checkAlarmList()
            }
            .navigationTitle(Text("Alarm View"))
            
            
            
        }
        
    }
}


//MARK: - PREVIEW
struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
