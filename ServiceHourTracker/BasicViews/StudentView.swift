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
    case ClassroomView
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
                VStack{
                    StudentClassesView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(settingsManager.title)
                    bottomPicks(selection: $settingsManager.tab)
                }
            case .SettingsView:
                
                VStack{
                    SettingsView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(settingsManager.title)
                    bottomPicks(selection: $settingsManager.tab)
                }
                
            case .HourBoardView:
                VStack{
                    HourBoardView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(settingsManager.title)
                    
                    bottomPicks(selection: $settingsManager.tab)
                }
            case .ClassroomView:
                VStack{
                    StudentRoomView().navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(settingsManager.title)
                    
                    
                }
                
               
            }
                   
                
            
        }
        .onChange(of: settingsManager.tab, { old, new in
            switch settingsManager.tab {
            case 0: settingsManager.title = "Hours Log"; currentView = .HourBoardView; break;
            case 2: settingsManager.title = "Classes"; currentView = .ClassesView; break;
            case 3: settingsManager.title = "Settings"; currentView = .SettingsView; break;
            case 4: settingsManager.title = "\(settingsManager.title)"; currentView = .ClassroomView; break;
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
