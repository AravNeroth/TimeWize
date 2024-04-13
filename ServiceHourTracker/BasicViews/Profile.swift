//
//  Profile.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/21/24.
//

import SwiftUI
import SwiftSMTP

struct Profile: View {
    
    @EnvironmentObject private var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @State var colorPaletteSheet = false
    @State private var refresh = true
    @State var showImgPicker = false
    @State private var userPfp = UIImage(resource: .image1)
    @State private var newPfp = UIImage(systemName: "person")
    @State var totalHoursEarned: [Classroom:Int] = [:]
    @AppStorage("authuid") var authID = ""
    @State var load = false
    
    var body: some View {
        if load{
            
            LoadingScreen()
                .onAppear{
                    load = false
                }
            
            
        }else{
        
            ZStack{
                ScrollView {
                    Spacer(minLength: 212.5)
                    NewHourBoardView(totalHoursEarned: $totalHoursEarned)
                }
                //            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height )
                .refreshable {
                    refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                    load = true
                }
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing)).shadow(radius: 3, y: 2).padding(.horizontal, 0).frame(height: 150)
                    .overlay(
                        ZStack{
                            
                            VStack{
                                
                                Spacer()
                                
                                HStack(alignment: .bottom){
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(.black)
                                            .frame(width: 80, height: 80)
                                        
                                        Image(uiImage: settingsManager.pfp)
                                            .resizable()
                                            .frame(width: 75,height: 75)
                                        
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .overlay(
                                                
                                                VStack{
                                                    Spacer()
                                                    HStack(alignment: .bottom){
                                                        Spacer()
                                                        ZStack{
                                                            Circle().frame(width: 25,height: 25).foregroundStyle(.black)
                                                            Button{
                                                                showImgPicker = true
                                                            }label:{
                                                                Image(systemName: "pencil").foregroundStyle(.white)
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            )
                                        
                                        
                                        
                                    }.padding(.leading, 10).shadow(radius: 3,y:3)
                                    Spacer()
                                }.padding(.top, 130)
                                
                            }
                            
                            
                            
                            HStack{
                                
                                Text(settingsManager.displayName)
                                    .padding(.leading, 95)
                                    .bold()
                                    .font(.largeTitle)
                                    .foregroundStyle(settingsManager.userColors.first!.isBright() ? .black : .white)
                                Spacer()
                                Button{
                                    colorPaletteSheet = true
                                    
                                }label: {
                                    Image(systemName: "paintpalette.fill").resizable().scaledToFill().frame(width: 25, height: 25).foregroundStyle(.white).padding(10)
                                }
                                Button{
                                    settingsManager.tab = 3
                                }label: {
                                    Image(systemName: "gearshape.fill").resizable().scaledToFit().frame(width: 25, height: 25)
                                }.padding(10).foregroundStyle(.white)
                                
                            }.padding(.top, 75)
                            
                        }
                        
                        
                    ).frame(height: 225)
                    .position(x: UIScreen.main.bounds.width / 2, y: -210)
                    .frame(height: 190)
                
                
            }
            .ignoresSafeArea()
            
            
            
            
            
            .sheet(isPresented: $colorPaletteSheet) {
                UserColorPalette(showPop: $colorPaletteSheet, refresh: $refresh)
                    .onDisappear() {
                        colorPaletteSheet = false
                    }
            }
            .sheet(isPresented: $showImgPicker) {
                ImagePicker(image: $newPfp)
                
            }.ignoresSafeArea()
                .onChange(of: newPfp) { oldValue, newValue in
                    if let newPfp = newPfp{
                        userPfp = newPfp
                        
                        settingsManager.pfp = newPfp
                        
                        uploadImageToUserStorage(id: "\(authID)", image: newPfp, file: "Pfp\(authID)")
                    }
                }
                .onAppear() {
                    for classroom in classInfoManager.allClasses {
                        for request in classInfoManager.allRequests {
                            if request.accepted && request.classCode == classroom.code {
                                if totalHoursEarned[classroom] != nil {
                                    totalHoursEarned[classroom]! += request.numHours
                                } else {
                                    totalHoursEarned[classroom] = request.numHours
                                }
                            }
                        }
                    }
                    
                }
            
            Button{
                // Define receiver before calling generatePDF
                let receiver = Mail.User(name: "Jonathan Kalsky", email: "jonathan.kalsky@gmail.com")
//verlyn.fischer.mobileapp@gmail.com
                generatePDF { pdfData, error in
                    if let error = error {
                        // Handle error
                        print("Error generating PDF: \(error.localizedDescription)")
                    } else if let pdfData = pdfData {
                        // Use pdfData
                        sendMail(to: receiver, pdfData: pdfData)
                    }
                }



                savePDF()
                
            }label: {
                Text("Generate Hour Log")
            }
        }
    }
}

#Preview {
    Profile()
}
