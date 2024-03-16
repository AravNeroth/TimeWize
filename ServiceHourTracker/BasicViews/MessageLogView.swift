//
//  MessageLogView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/15/24.
//

import SwiftUI

struct MessageLogView: View {
    @Binding var lastChats: [String:Message] 
    var recipientEmail: String
    @State var messages: [Message] = []
    @State private var loading = true
    @EnvironmentObject private var settingsManager: SettingsManager
    @AppStorage("uid") private var userID = ""
    @StateObject private var messageManager = MessageManager()
    var body: some View {
        if messageManager.loading {
            LoadingScreen()
                .onAppear(){
                     messageManager.getMessagesList(user: userID, from: recipientEmail)
                }
        }else{
            ScrollViewReader{ proxy in
                ScrollView{
                    ForEach(messageManager.messages, id: \.self){ message in
                        MessageBubble(message: message).id(message)
                    }
                    .onAppear{
                        print(messageManager.messages.last)
                        proxy.scrollTo(messageManager.messages.last, anchor: .bottom)
                    }
                }
                .onChange( of: messageManager.messages) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue.last , anchor: .bottom)
                    }
                    
                }
                
            }
            MessageField(recipientEmail: recipientEmail, lastChats: $lastChats)
        }
    }
}

