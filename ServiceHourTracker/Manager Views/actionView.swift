//
//  actionView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/26/24.
//

import SwiftUI

struct actionView: View {
    @State private var selection = 0
    @EnvironmentObject private var settingsManager: SettingsManager
    enum currAction {
        case Messages
        case Requests
    }
    @State var currActionSelected: currAction = .Messages
    var body: some View {
        VStack{
            Picker(selection: $selection, label: Text("action mode")){
                Text("Messages").tag(0)
                Text("Requests").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            
            switch currActionSelected{
            case .Messages:
                MessagingView()
            case .Requests:
                RequestListView(fromManSide: true)
            }
            
        }
        
        
            .onChange(of: selection) { oldValue, newValue in
                if selection == 0{
                    currActionSelected = .Messages
                    settingsManager.title = "Messages"
                }else{
                    currActionSelected = .Requests
                    settingsManager.title = "Requests"
                }
            }
    }
    
        
}

#Preview {
    actionView()
}
