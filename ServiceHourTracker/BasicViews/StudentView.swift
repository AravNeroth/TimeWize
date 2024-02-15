//
//  TestView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/10/23.
//  Edited by Jonathan Kalsky 1/19/24
//

import SwiftUI
enum view{
    case HourBoardView
    case SettingsView
    case ClassesView
    case classroomView
    case ManagerTestClass
}

var currentView: view = .ClassesView


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
                
                classroomView().navigationBarTitleDisplayMode(.inline).navigationTitle(settingsManager.title)
                
            case .ManagerTestClass:
                           ManagerTestClass()
            }
                   
                
            
        }.onChange(of: settingsManager.tab, { old, new in
            switch settingsManager.tab{
            case 0: settingsManager.title = "Hours Log"; currentView = .HourBoardView
            case 2: settingsManager.title = "Classes"; currentView = .ClassesView
            case 3: settingsManager.title = "Settings"; currentView = .SettingsView
            case 4: settingsManager.title = "\(settingsManager.title)"; currentView = .classroomView
            case 5: settingsManager.title = "ManagerTest"; currentView = .ManagerTestClass
            default:
                settingsManager.title = ""
            }
        })
        .onAppear(){
            print("appeared")
        }
        .preferredColorScheme(.dark)
    }
}





//MARK: toolbar
//struct bottomPicks: View {
//    @Binding var selection: Int
//    @EnvironmentObject var settingsManager: SettingsManager
//    var body: some View {
//        HStack{
//            Spacer()
//            Button{
////                currentView = .HourBoardView
//                settingsManager.tab = 0
//            }label: {
//                VStack{
////                                    Spacer()
//                    Image(systemName: "clock.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                    Text("Hours Log").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                }
//            }
//            Spacer()
//            Button{
////                currentView = .ClassesView
////                selection = 2
//                settingsManager.tab = 2
//            }label: {
//                VStack{
////                                    Spacer()
//                    Image(systemName: "house.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                    Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                }
//            }
//            Spacer()
//            Button{
////                currentView = .SettingsView
//                settingsManager.tab = 3
//            }label: {
//                VStack{
//
//                    Image(systemName: "gearshape.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                    Text("Settings").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
//                }
//            }
//            Spacer()
//        }.padding(.top)
//    }
//}

#Preview {
    StudentView()
        
}
