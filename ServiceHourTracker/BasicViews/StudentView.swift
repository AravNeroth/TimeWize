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
    case ManagerRoomView
    case MessagesView
    case Profile
}

var currStudentViewSelected: currStudentView = .ClassesView


struct StudentView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State var tabSelection = 2
    @State var title = ""
    @State private var onMessagingLog = false
    var body: some View {
        NavigationView {
         

            
            switch currStudentViewSelected {
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
                    HourBoardView()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle(settingsManager.title)
                    
                    bottomPicks(selection: $settingsManager.tab)
                }
            case .ClassroomView:
                VStack{
                    StudentRoomView()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(settingsManager.title)
                    
                    
                }
                
            case .ManagerRoomView:
                VStack {
                    ManagerRoomView()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(settingsManager.title)
                        .navigationBarBackButtonHidden(true)
                }
            case .MessagesView:
                VStack{
                    MessagingView(messaging: $onMessagingLog)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationTitle(onMessagingLog ? "" : settingsManager.title)
                    
                    bottomPicks(selection: $settingsManager.tab)
                }
            
                
            case .Profile:
                VStack{
                    Profile().ignoresSafeArea(.all)
//                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
//                        .navigationTitle(settingsManager.title)
                        
                    bottomPicks(selection: $settingsManager.tab)
                }
            }
                   
                
            
        }
        .onAppear{
            if currStudentViewSelected == .ClassesView {
                settingsManager.tab = 2
            }else if currStudentViewSelected == .SettingsView{
                settingsManager.tab = 3
            }
        }
        .onChange(of: settingsManager.tab, { old, new in
            switch settingsManager.tab {
            case 0: settingsManager.title = "Hours Log"; currStudentViewSelected = .HourBoardView; break;
            case 2: settingsManager.title = "Classes"; currStudentViewSelected = .ClassesView; break;
            case 3: settingsManager.title = "Settings"; currStudentViewSelected = .SettingsView; break;
            case 4: settingsManager.title = "\(settingsManager.title)"; currStudentViewSelected = .ClassroomView; break;
            case 5: settingsManager.title = "\(settingsManager.title)"; currStudentViewSelected = .ManagerRoomView; break;
            case 6: settingsManager.title = "Messages"; currStudentViewSelected = .MessagesView; break;
            case 7: settingsManager.title = "Profile"; currStudentViewSelected = .Profile; break;
            default:
                settingsManager.title = ""
            }
        })
        
//        .preferredColorScheme(.dark)
    }
}

#Preview {
    StudentView()
        
}
