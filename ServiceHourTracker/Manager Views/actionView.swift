//
//  actionView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/26/24.
//

import SwiftUI


enum currAction {
    case Messages
    case Requests
}
var currActionSelected: currAction = .Messages


struct actionView: View {
    @State private var selection = 0
    @EnvironmentObject private var settingsManager: SettingsManager
    
    
    @Binding var messageOnLog: Bool
    @Binding var hideTitleAndPicker: Bool
    @AppStorage("uid") var userID = ""
    var body: some View {
        VStack{
            if !messageOnLog {
                Picker(selection: $selection, label: Text("action mode")){
                    Text("Messages").tag(0)
                    Text("Requests").tag(1)
                }.animation(.easeIn(duration: 2), value: messageOnLog).padding( 20).pickerStyle(SegmentedPickerStyle())
                    .onAppear{
                        if currActionSelected == .Requests {
                            selection = 1
                        }else{
                            selection = 0
                        }
                    }
                    
            }
        
            switch currActionSelected{
                case .Messages:
                    MessagingView(messaging: $messageOnLog)
                case .Requests:
                    // loads ReqListView if student is True/False
                RequestListView(fromManSide: settingsManager.isManagerMode)
                    .onDisappear{
                        //update latest requests number
                        updateLatestRequestsCount(userID: userID)
                    }
            }
            
        }
        
            
            .onChange(of: selection) { oldValue, newValue in
                if selection == 0{
                    currActionSelected = .Messages
                    settingsManager.title = "Messages"
                }else{
                    //   if student is True/False
                    if (settingsManager.isManagerMode) {
                        currActionSelected = .Requests
                        settingsManager.title = "Manager Requests"
                    }
                    else{
                        currActionSelected = .Requests
                        settingsManager.title = "Student Requests"
                    }
                    
                }
            }
    }
    
        
}

