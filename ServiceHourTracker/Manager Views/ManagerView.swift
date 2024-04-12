//
//  File.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 2/6/24.
//

import Foundation
import SwiftUI

enum ManagerViews{
    case SettingsView
    case ManagerClass
    case ManagerHome
    case RequestsView
    case MessagesView
    case actionView
}

var currManagerView: ManagerViews = .ManagerHome
struct ManagerView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classData: ClassData
    @State var tabSelection = 0
    @State var title = ""
    @State var classes = ManagerClassesView()
    
    var body: some View{
        
        NavigationView{
            switch currManagerView {
            case .SettingsView:
                VStack{
                    
                    SettingsView().navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
                    ManagerBottomBar(selection: $tabSelection)
                    
                }

            case .ManagerHome:
                VStack{
                classes.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
                ManagerBottomBar(selection: $tabSelection)
                    
                }
            case .actionView:
                VStack{
                    actionView()
                        .navigationTitle(settingsManager.title)
                        .navigationBarTitleDisplayMode(.inline)
                    
                    ManagerBottomBar(selection: $tabSelection)
                }
            case .RequestsView:
                VStack {
                    RequestListView(fromManSide: true).navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
                        
                    ManagerBottomBar(selection: $tabSelection)
                        
                    
                }
            case .ManagerClass:
                ManagerRoomView()
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle(settingsManager.title)
                    .navigationBarTitleDisplayMode(.inline)
            case .MessagesView:
                VStack{
                    MessagingView().navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
                        
                    ManagerBottomBar(selection: $tabSelection)
                        
                    
                }
            }
            
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                if currManagerView == .SettingsView{
                    settingsManager.manTab = 1
                }else if currManagerView == .ManagerHome{
                    settingsManager.manTab = 0
                }
            }
        
            .onChange(of: settingsManager.manTab, { old, new in
                switch settingsManager.manTab{
                case 0: settingsManager.title = "Classes"; currManagerView = .ManagerHome
                case 1: settingsManager.title = "Settings"; currManagerView = .SettingsView
//                case 2: currManagerView = .ManagerClass
                case 2: settingsManager.title = "Requests"; currManagerView = .RequestsView
                case 3: currManagerView = .ManagerClass; 
                case 4: currManagerView = .MessagesView; settingsManager.title = "Messages"
                case 5: currManagerView = .actionView; settingsManager.title = "Messages"
                default:
                    settingsManager.title = ""
                }
            })
        
            
    }
    
    
}

