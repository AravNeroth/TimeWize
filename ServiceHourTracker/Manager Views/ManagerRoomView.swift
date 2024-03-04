//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Verlyn Fischer on 2/15/24.
//

import Foundation
import SwiftUI

struct ManagerRoomView: View {
    @State private var showPpl = false
    @State private var showPalette = false
    @State private var showManOptions = false
    @State private var imageSelection = false
    @State private var homeImageSelection = false
    @State private var newBanner = UIImage(systemName: "person")
    @State private var newHome = UIImage(systemName: "person")
    @EnvironmentObject var classData: ClassData
    @EnvironmentObject private var classInfoManager: ClassInfoManager
    @EnvironmentObject private var settingsManager: SettingsManager
    @State private var loaded = false
    @State private var showTaskPopup = false
    @State private var announcements: [Announcement] = []
    @State var colors: [Color] = [.green4, .green6] //keep last as green6 for default purpouses
    @State var tasks: [ClassTask] = []
    @State var classImage: UIImage? = UIImage(resource: .image1)
    @State var useDefaults = false
    @State var showDate = false
    @State var title = "Title"
    var body: some View{
        
        if !loaded {
            LoadingScreen()
                .onAppear(){
                    downloadImageFromClassroomStorage(code: "\(classData.code)", file: "Home\(settingsManager.title).jpg") { image in
                        if let image = image {
                            classImage = image
                        }
                        
                        getColorScheme(classCode: classData.code) { scheme in
                            if scheme.count != 0 {
                                if scheme.last!.luminance > 0.8 {
                                    useDefaults = true
                                }
                                
                                colors = scheme
                            }
                            
                            getClassInfo(classCloudCode: classData.code) { classroom in
                                if let classroom = classroom {
                                    title = classroom.title
                                }
                                
                                getTasks(classCode: classData.code) { newTasks in
                                    tasks = newTasks
                                    
                                    getAnnouncements(classCode: classData.code) { announcements in
                                        
                                        self.announcements = announcements
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            loaded = true
                                        }

                                    }
                                    
                                }
                            }
                        }
                    }
                        
                    }
                
            
        }else{
            NavigationStack{
                ScrollView{
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 170)
                        .padding(.horizontal, 10.0)
                        .shadow(radius: 2.0, y: 2.0)
                        .overlay(
                            ZStack {
                                
                                if let classImage = classImage {
                                    Image(uiImage: classImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 170)
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        .padding(.horizontal, 10.0)
                                        .opacity(0.5)
                                }
                                
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        
                                        Text(title)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 30.0)
                                            .padding(.vertical, 15.0)
                                            .foregroundStyle(.white)
                                            .shadow(radius: 2.0, y: 2.0)
                                    }
                                    
                                    Spacer()
                                }
                            }
                        ).padding(.bottom)
                    
                    AnnouncementField().animation(.easeInOut(duration: 0.6), value: loaded)
                    Spacer()
                    
                    
                    ForEach(announcements, id:\.self) { ancmnt in
                        HStack{
//                            Button{
//                                showDate.toggle()
//                            }label:{
//                                Text(ancmnt.message).frame(width: 375, height: 20).stroke(.gray)
//                            }
//                            if showDate{
//                                Text("\(ancmnt.date)").padding(.trailing)
//                            }
                      
                        }
                    }
//                    if tasks.count != 0 {
//                        ForEach(tasks, id:\.self) { task in
//                            TaskView(classCode: classData.code, title: "\(task["title"] ?? "No Title")", date: "\(task["date"] ?? "0/0/0000")", totalPpl: Int(task["size"] ?? "0")!, numHours: Int(task["hours"] ?? "0")!)
//                        }
//                    }
                    
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
            
            
            .sheet(isPresented: $showManOptions) {
                
//                ManagerPopup(showManOptions: $showManOptions, showPpl: $showPpl, homeImageSelection: $homeImageSelection, showTaskPopup: $showTaskPopup, showPalette: $showPalette)
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
                .presentationDetents([.fraction(0.5)])
                
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
    
    
}



