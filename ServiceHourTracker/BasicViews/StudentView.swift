//
//  TestView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/10/23.
//  Edited by Jonathan Kalsky 1/19/24
//

import SwiftUI
enum currStudentView{
    case HourBoardView
    case SettingsView
    case ClassesView
    case classroomView
//    case ManagerClass
}

var currentView: currStudentView = .ClassesView


struct StudentView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State var tabSelection = 2
    @State var title = ""
    
    var body: some View {
        NavigationView {
         

            
            switch currentView {
            case .ClassesView:
                ClassesView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(settingsManager.title)
            case .SettingsView:
                SettingsView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(settingsManager.title).toolbar {
                    
                    
                    ToolbarItem(placement: .bottomBar) {
                        
                        bottomPicks(selection: $settingsManager.tab)
                        
                    }
                }
            case .HourBoardView:
                HourBoardView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(settingsManager.title).toolbar {
                    
                    
                    ToolbarItem(placement: .bottomBar) {
                        
                        bottomPicks(selection: $settingsManager.tab)
                        
                    }
                }
            case .classroomView:
                
                ClassroomView().navigationBarTitleDisplayMode(.inline).navigationTitle(settingsManager.title)
                
//            case .ManagerClass:
//                ManagerClass(loaded: .constant(true))
            }
                   
                
            
        }
        .onChange(of: settingsManager.tab, { old, new in
            switch settingsManager.tab{
            case 0: settingsManager.title = "Hours Log"; currentView = .HourBoardView
            case 2: settingsManager.title = "Classes"; currentView = .ClassesView
            case 3: settingsManager.title = "Settings"; currentView = .SettingsView
            case 4: settingsManager.title = "\(settingsManager.title)"; currentView = .classroomView
//            case 5: settingsManager.title = "ManagerTest"; currentView = .ManagerTestClass
            default:
                settingsManager.title = ""
            }
        })
        .onAppear(){
            print("appeared")
        }
//        .preferredColorScheme(.dark)
    }
}






#Preview {
    StudentView()
        
}
