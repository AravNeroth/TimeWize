//
//  MessagingView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/12/24.
//

import SwiftUI


struct MessagingView: View {
    @State var chats: [String] = []
    @State var loading = true
    @State var images: [String:Image] = [:]
    @State var lastChats: [String:Message] = [:]
    @EnvironmentObject var settingsManager: SettingsManager
    @AppStorage("uid") private var userID = ""
    @StateObject private var messageManager = MessageManager()
    @State var names: [String:String] = [:]
    var body: some View {
        
        if loading{
            LoadingScreen()
                .onAppear(){
                    getChatsOf(user: userID) { chats in
                        
                        
                        self.chats = chats
                        
                        messageManager.getNames(emails: chats) { names in
                            self.names = names
                        }
                        messageManager.getImagesForChats(chats: chats){ images in
                            self.images = images
                        }
                        messageManager.getLatestMessage(chats: chats, user: userID){ lastChats in
                            self.lastChats = lastChats
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            loading = false
                        }
                        
                    }
                }
        }else{
            
                ScrollView{
                    
                    ForEach(chats, id: \.self){ chatWith in
                        NavigationLink {
                            MessageLogView(lastChats: $lastChats, recipientEmail: chatWith)
                                .navigationBarTitleDisplayMode(.inline)
                            
                        }label:{
                            
                            
                            VStack{
                                HStack{
                                    VStack(alignment: .leading){
                                        if let image = images[chatWith]{
                                            Circle()
                                                .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    image
                                                        .resizable()
                                                        .clipShape(Circle())
                                                    
                                                    
                                                )
                                                .shadow(radius: 3, y: 1)
                                                .padding(.all, 10)
                                        }else{
                                            
                                            Circle()
                                                .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .frame(width: 40, height: 40)
                                                .overlay {
                                                    Text(chatWith.prefix(1)).bold().tint(.white)
                                                }.shadow(radius: 5, y: 1)
                                                .padding(.all, 10)
                                        }
                                    }
                                    
                                    
                                    VStack(alignment: .leading){
                                        Text(names[chatWith] ?? "").bold().font(.title3)
                                        if let lastMessage = lastChats[chatWith]{
                                            Text(lastMessage.message).font(.footnote)
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        if let lastMessage = lastChats[chatWith]{
                                            Text("\(formatDate(lastMessage.time))")
                                        }
                                        Spacer()
                                    }
                                    
                                    
                                    
                                }.padding(.all, 20)
                                //                            VStack{
                                Divider().padding(.leading, 100)
                                //                            }
                                
                                
                            }
                            
                            
                        }.buttonStyle(PlainButtonStyle())
                        /*
                         NavigationLink {
                         MessageLogView(recipientEmail: chatWith).navigationBarTitleDisplayMode(.inline)
                         } label: {
                         VStack{
                         Divider()
                         
                         RoundedRectangle(cornerRadius: 15.0)
                         .fill(.background)
                         .stroke(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                         .frame(height: 100)
                         .padding(.horizontal, 10.0)
                         .shadow(radius: 2.0, y: 2.0)
                         .overlay(
                         VStack {
                         HStack {
                         if let image = images[chatWith]{
                         Circle()
                         .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                         .frame(width: 40, height: 40)
                         .overlay(
                         image
                         .resizable()
                         .clipShape(Circle())
                         
                         
                         )
                         .padding(.leading, 20.0)
                         }
                         VStack(alignment: .leading) {
                         Text("\(chatWith)")
                         .multilineTextAlignment(.leading)
                         .font(.title3)
                         .bold()
                         
                         
                         if let lastM = lastChats[chatWith] {
                         Text("\(formatDate(lastM.time))")
                         .multilineTextAlignment(.leading)
                         .font(.caption)
                         
                         }
                         
                         }
                         
                         Spacer()
                         
                         
                         }
                         }
                         )
                         
                         
                         Text(chatWith).padding([.top,.bottom], 10)
                         
                         
                         Divider()
                         }.padding()
                         }.buttonStyle(PlainButtonStyle())
                         */
                        
                        
                    }
                    
                    
                    
                }
                
            
        }
    }
}

#Preview {
    MessagingView()
}
