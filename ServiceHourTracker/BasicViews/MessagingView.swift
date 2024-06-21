//
//  MessagingView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/12/24.
//

import SwiftUI


struct MessagingView: View {

    @EnvironmentObject var settingsManager: SettingsManager
    @AppStorage("uid") private var userID = ""
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @State var refresh = false
    @State private var showNewMessagingSheet = false //to present the sheet for a new contact
    @Binding var messaging: Bool
    var body: some View {
        NavigationView{
            
            
            if
//                messageManager.chatNames.count != messageManager.userChats.count ||
//                messageManager.lastMessages.count != messageManager.userChats.count ||
                    refresh {
                
                LoadingScreen()
                    
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now()+5){
                            refresh = false
                        }
                        
                        
                        let DG = DispatchGroup()
                        DG.enter()
                        
                        
                        messageManager.updateData(userID: userID){ _ in
                            DG.leave()
                            
                        }
                        
                        DG.notify(queue: .main) {
                            refresh = false
                        }
                    }
                
            } else if messageManager.userChats.isEmpty {
                ScrollView{
                    Spacer()
                    Text("No Recent Chats")
                    Spacer()
                }
                    .refreshable {
                        refresh = true
                        refreshVars(settingsManager: settingsManager, messageManager: messageManager, classInfoManager: classInfoManager)
                    }
                    .onAppear{
                        messageManager.updateData(userID: userID)
                    }
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            Button{
                                showNewMessagingSheet = true
                            }label:{
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
            }else{
                
                ScrollView{
                    
                    ForEach(messageManager.userChats, id: \.self){ chatWith in
                        
                        NavigationLink {
                            
                            MessageLogView(lastChats: $messageManager.lastMessages, recipientEmail: chatWith)
                                .onAppear{
                                    messaging = true
                                    
                                }
                                .onDisappear{
                                    messaging = false
                                }
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle(messageManager.chatNames[chatWith] ?? chatWith)

                            
                        }label:{
                            
                            
                            VStack{
                                HStack{
                                    VStack(alignment: .leading){
                                        if let image = messageManager.chatImages[chatWith]{
                                            Circle()
                                                .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .frame(width: 52, height: 52)
                                                .overlay(
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(Circle())
                                                    
                                                    
                                                )
                                                .shadow(radius: 3, y: 1)
                                                .padding(.all, 5)
                                        }else{
                                            
                                            Circle()
                                                .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .frame(width: 52, height: 52)
                                                .overlay {
                                                    Text(chatWith.prefix(1)).bold().tint(.white)
                                                }.shadow(radius: 5, y: 1)
                                                .padding(.all, 5)
                                        }
                                    }
                                    
                                    
                                    VStack(alignment: .leading){
                                        Text(messageManager.chatNames[chatWith] ?? "").bold().font(.title3)
                                        if let lastMessage = messageManager.lastMessages[chatWith]{
                                            Text(lastMessage.message).font(.footnote)
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        if let lastMessage = messageManager.lastMessages[chatWith]{
                                            Text("\(formatDate(lastMessage.time))")
                                        }
                                        Spacer()
                                    }
                                    
                                    
                                    
                                }.padding(.all, 8)
                                
                                Divider()
                                    .padding(.horizontal, 8)
                                
                                
                                
                            }
                            
                            
                        }.buttonStyle(PlainButtonStyle())
                        
                        
                        
                    }
                    
                    
                    
                }
                .refreshable {
                    refresh = true
                    refreshVars(settingsManager: settingsManager, messageManager: messageManager, classInfoManager: classInfoManager)
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            showNewMessagingSheet = true
                        }label:{
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
                
                
                
                
                
            }
        }
            .sheet(isPresented: $showNewMessagingSheet) {
                NewMessage()
                    .onDisappear {
                        showNewMessagingSheet = false
                    }
                    
            }
            .onAppear{
                messaging = false
            }
    }
}

