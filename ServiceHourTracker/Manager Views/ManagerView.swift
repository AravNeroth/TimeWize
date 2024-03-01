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
//    case ManagerClass
    case ManagerHome
    //case historyLog
    case RequestsView
}

var currManagerView: ManagerViews = .ManagerHome
struct ManagerView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State var tabSelection = 0
    @State var title = ""
    
    
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
                ManagerClassesView().navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
                ManagerBottomBar(selection: $tabSelection)
                    
                }
            case .RequestsView:
                VStack{
                    ManagerReqListView().navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
                        
                    ManagerBottomBar(selection: $tabSelection)
                        
                    
                }
            }
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline)
        
        
            .onChange(of: settingsManager.manTab, { old, new in
                switch settingsManager.manTab{
                case 0: settingsManager.title = "Classes"; currManagerView = .ManagerHome
                case 1: settingsManager.title = "Settings"; currManagerView = .SettingsView
//                case 2: currManagerView = .ManagerClass
                case 2: settingsManager.title = "Requests"; currManagerView = .RequestsView
                default:
                    settingsManager.title = ""
                }
            })
        
            .onAppear(){
                settingsManager.manTab = 0
            }
    }
    
    
}

