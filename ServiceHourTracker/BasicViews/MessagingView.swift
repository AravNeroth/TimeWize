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
    var body: some View {
        
        if  messageManager.chatNames.count != messageManager.userChats.count ||
//          messageManager.chatImages.count != messageManager.userChats.count ||
            messageManager.lastMessages.count != messageManager.userChats.count ||
            refresh {
            
            let timer = Timer.publish(every: 2, on: .main, in: .common)
            
            LoadingScreen()
                .onReceive(timer, perform: { _ in
                    messageManager.updateData(userID: userID){ _ in
                        refresh = false
                    }
                })
                .onAppear(){
                    messageManager.updateData(userID: userID){ _ in
                        refresh = false
                    }
                }
            
        } else if messageManager.userChats.isEmpty {
            Text("No Recent Chats")
                .refreshable {
                    refresh = true
                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                }
                .onAppear{
                messageManager.updateData(userID: userID)
                }
        }else{
            
                ScrollView{
                    
                    ForEach(messageManager.userChats, id: \.self){ chatWith in
                        
                            NavigationLink {
                                MessageLogView(lastChats: $messageManager.lastMessages, recipientEmail: chatWith)
                                    .navigationBarTitleDisplayMode(.inline).navigationTitle(messageManager.chatNames[chatWith] ?? chatWith)
                                    .toolbar{
                                        ToolbarItem(placement: .topBarLeading) {
                                            if let image = messageManager.chatImages[chatWith]{
                                                Circle()
                                                    .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        image
                                                            .resizable()
                                                            .clipShape(Circle())
                                                        
                                                        
                                                    )
                                                    .shadow(radius: 1, y: 1)
                                                    .padding(.all, 10)
                                            }else{
                                                
                                                Circle()
                                                    .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .frame(width: 40, height: 40)
                                                    .overlay {
                                                        Text(chatWith.prefix(1)).bold().tint(.white)
                                                    }.shadow(radius: 1, y: 1)
                                                    .padding(.all, 10)
                                            }
                                        }
                                    }
                                
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
                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                }
                
            
        }
    }
}

#Preview {
    MessagingView()
}
