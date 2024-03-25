//
//  Profile.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/21/24.
//

import SwiftUI

struct Profile: View {
    
    @EnvironmentObject private var settingsManager: SettingsManager
    @State var colorPaletteSheet = false
    @State private var refresh = true
    @State var showImgPicker = false
    @State private var userPfp = UIImage(resource: .image1)
    @State private var newPfp = UIImage(systemName: "person")
    @AppStorage("authuid") var authID = ""
    var body: some View {
        
        
        ZStack{
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing)).padding(.horizontal, 0).frame(height: 150)
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
                                    
                                    
                                    
                                }.padding(.leading, 10)
                                Spacer()
                            }.padding(.top, 130)
                            
                        }
                        
                        
                        
                        HStack{
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
            /*
            VStack(alignment: .leading){
                Spacer()
                
                HStack(alignment: .bottom){
                    ZStack{
                        Circle()
                            .foregroundStyle(.black)
                            .frame(width: 80, height: 80)
                        
                            Image(.image1)
                                .frame(width: 75,height: 75)
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay(
                            
                                    VStack{
                                        Spacer()
                                        HStack(alignment: .bottom){
                                            Spacer()
                                            ZStack{
                                                Circle().frame(width: 25,height: 25).foregroundStyle(.black)
                                                Image(systemName: "pencil").foregroundStyle(.white)
                                            }
                                        }
                                        
                                    }
                            )
                            
                        
                        
                    }.padding(.leading, 10)
                    Spacer()
                }
                
            }
            */
            
        }.ignoresSafeArea().frame(height: 225).position(x: UIScreen.main.bounds.width / 2, y: 75)
        
        
    ScrollView{
        
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

            
    }
}

#Preview {
    Profile()
}
