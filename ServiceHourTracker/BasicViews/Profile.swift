//
//  Profile.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/21/24.
//

import SwiftUI

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
    
    var body: some View {
        
        
        ZStack{
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
                                Image(systemName: "paintpalette.fill").resizable().scaledToFit().frame(width: 25, height: 25).foregroundStyle(.white).padding(10)
                            }
                            Button{
                                settingsManager.tab = 3
                            }label: {
                                Image(systemName: "gearshape.fill").resizable().scaledToFit().frame(width: 25, height: 25)
                            }.padding(10).foregroundStyle(.white)
                            
                        }.padding(.top, 75)
                        
                    }
                    
                
                )
            
            
        }.ignoresSafeArea().frame(height: 225).position(x: UIScreen.main.bounds.width / 2, y: 75).frame(height: 190)
        
        
        ScrollView {
            NewHourBoardView(totalHoursEarned: $totalHoursEarned)
        }
        .refreshable {
            refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
        }
    
        
        .sheet(isPresented: $colorPaletteSheet) {
            UserColorPalette(showPop: $colorPaletteSheet, refresh: $refresh)
                .onDisappear() {
                    colorPaletteSheet = false
                }
        }
        .sheet(isPresented: $showImgPicker) {
            ImagePicker(image: $newPfp)
        
        }
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
    }
}

#Preview {
    Profile()
}
