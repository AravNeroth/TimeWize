//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Verlyn Fischer on 2/15/24.
//

import Foundation
import SwiftUI

struct ManagerClassroomView: View {
    @State private var showPpl = false
    @State private var showPalette = false
    @State private var showManOptions = false
    //@Binding var loaded: Bool
    @State private var imageSelection = false
    @State private var homeImageSelection = false
    @State private var newBanner = UIImage(systemName: "person")
    @State private var newHome = UIImage(systemName: "person")
    @EnvironmentObject var classData: ClassData
    @EnvironmentObject private var classInfoManager: ClassInfoManager
    @EnvironmentObject private var settingsManager: SettingsManager
    @State private var loaded = false
    @State private var showTaskPopup = false
    var body: some View{
        NavigationStack{
            VStack{
                AnnouncementField().animation(.easeInOut(duration: 0.6), value: loaded).padding()
                Spacer()
                Text("manager class: \(classData.code)")
                Spacer()
            }
            
            
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline).toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button{
                        if !(showPpl || homeImageSelection || showPalette || showTaskPopup) {
                            showManOptions = true
                        }
                    }label: {
                        Image(systemName: "gearshape").tint((showPpl || homeImageSelection || showPalette || showTaskPopup) ? .gray : .blue)
                    }
                    Spacer()

                }
            }
            
        }
        .onAppear(){
            loaded = true
        }
        .sheet(isPresented: $showManOptions) {
            
                VStack{
                    //                Divider().padding()
                    Spacer()
                    Button{
                        withAnimation(.bouncy){
                            showManOptions = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                                showPpl = true
                            }
                        }
                    }label: {
                        HStack{
                            Image(systemName: "person.3")
                            Text("Class People")
                        }
                    }.padding()
                    Divider().padding()
                    Button{
                        withAnimation(.easeInOut(duration: 1.5)){
                            showManOptions = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                                homeImageSelection = true
                            }
                       
                        }
                        //                    imageSelection = true -> banner   (not in use anymore)
                    }label: {
                        HStack{
                            Image(systemName: "photo.fill")
                            Text("Edit Class Photo")
                        }
                    }.padding()
                    Divider().padding()
                    Button{
                        showManOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                            showPalette = true
                        }
                        
                        
                    }label: {
                        HStack{
                            Image(systemName: "paintpalette.fill")
                            Text("Class Colors")
                        }
                    }.padding()
                    Divider().padding()
                    Button{
                        
                        showManOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                            showTaskPopup = true
                        }
                     
                        
                    }label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Add Task")
                        }
                    }.padding()
                }
                .presentationDetents([.fraction(0.5)])//[.height(50.0)]
            
        }
        
        .sheet(isPresented: $showPpl) {
            ManagerPeopleView(code: classData.code, classTitle: settingsManager.title, isShowing: $showPpl)
                .onDisappear(){
                    showPpl = false
            
                }
        }
        .fullScreenCover(isPresented: $imageSelection) {
            ImagePicker(image: $newBanner)
                .onDisappear(){
                    imageSelection = false
            
                }
                .ignoresSafeArea(edges: .bottom)
        }
//        .fullScreenCover(isPresented: $homeImageSelection) {
//            ImagePicker(image: $newHome)
//                
//                .ignoresSafeArea(edges: .bottom)
//        }
        .sheet(isPresented: $homeImageSelection, content: {
            ImagePicker(image: $newHome)
            .onDisappear(){
                homeImageSelection = false
        
            }

            .ignoresSafeArea(edges: .bottom)
        })
        .sheet(isPresented: $showPalette, content: {
            ColorPalette(showPop: $showPalette).animation(.easeInOut, value: showPalette)
                .presentationDetents([.height(600)])
                .onDisappear(){
                    showPalette = false
                }
        }).animation(.easeInOut, value: settingsManager.title)
        
        .sheet(isPresented: $showTaskPopup, content: {
            taskPopup(showPop: $showTaskPopup)
                .frame(width: 375, height: 600)
                .onDisappear(){
                    showTaskPopup = false
                }
        })
        .onChange(of: newHome, {
            if let newHome = newHome{
                uploadImageToClassroomStorage(code: classData.code, image: newHome, file: "Home\(settingsManager.title)")
                
            }
        })
        .onChange(of: newBanner) {
            if let newBanner = newBanner{
                print("code: \(classData.code)")
                uploadImageToClassroomStorage(code: classData.code , image: newBanner, file: "\(settingsManager.title)")
                classInfoManager.managerClassImages[settingsManager.title] = newBanner
            }
        }
    }
}






