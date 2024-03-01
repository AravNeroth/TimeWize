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

    //@Binding var loaded: Bool
    @State private var imageSelection = false
    @State private var homeImageSelection = false
    @State private var newBanner = UIImage(systemName: "person")
    @State private var newHome = UIImage(systemName: "person")
    @EnvironmentObject var classData: ClassData
    @EnvironmentObject private var classInfoManager: ClassInfoManager
    @EnvironmentObject private var settingsManager: SettingsManager
   
    @State private var showTaskPopup = false
    var body: some View{
        NavigationStack{
            VStack{
                Text("manager class: \(classData.code)")
                if showTaskPopup {
                    taskPopup(showPop: $showTaskPopup)
                        .frame(width: 375, height: 500, alignment: .center).offset(y: -130)
                }
                if showPalette {
                    ColorPalette(showPop: $showPalette).frame(width: 375, height: 500, alignment: .center).offset(y: -130)
                }
            }
            
            
        }.navigationTitle(settingsManager.title).navigationBarTitleDisplayMode(.inline).toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button{
                        showPpl = true
                    }label: {
                        Image(systemName: "person.3")
                    }
                    
                    Menu{
                        Button("Banner"){
                            imageSelection = true
                        }
                        Button("Home"){
                           homeImageSelection = true
                        }
                    }label: {
                        Image(systemName: "photo.fill")
                    }
                    
                    Button{
                        showPalette = true
                    }label: {
                        Image(systemName: "paintpalette.fill")
                    }
                    Button{
                        showTaskPopup = true
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
        }
        .sheet(isPresented: $showPpl) {
            PeopleListView(code: classData.code, classTitle: settingsManager.title, isShowing: $showPpl)
        }
        .fullScreenCover(isPresented: $imageSelection) {
            ImagePicker(image: $newBanner)
                
                .ignoresSafeArea(edges: .bottom)
        }
        
        .sheet(isPresented: $homeImageSelection, content: {
            ImagePicker(image: $newHome)
            
                .ignoresSafeArea(edges: .bottom)
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






