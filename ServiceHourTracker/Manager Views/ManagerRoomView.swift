//
//  NewManagerRoomView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/7/24.
//

import SwiftUI

struct ManagerRoomView: View {
    
    @AppStorage("uid") var userID = ""
    @State var title: String = "Title"
    @State var colors: [Color] = [.green4, .green6] // keep last as green6 for default purpouses
    @State var tasks: [ClassTask] = []
    @State var announcements: [Announcement] = []
    @State var allComponents: [ClassComponent] = []
    @State var managerNames: [String:String] = [:]
    @State var classImage: UIImage? = UIImage(resource: .image1)
    @State var newHomeImage: UIImage? = UIImage(resource: .image1)
    @State var loading = true
    @State var showMenu = false
    @State var showPplList = false
    @State var showImageSelection = false
    @State var showTask = false
    @State var showColorPalette = false
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    @State var useDefaults = false
    
    var body: some View {
            if loading {
                LoadingScreen()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ignoresSafeAreaEdges: .all)
                    .onAppear() {
                        allComponents = []
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            downloadImageFromClassroomStorage(code: "\(classData.code)", file: "Home\(settingsManager.title).jpg") { image in
                                if let image = image {
                                    classImage = image
                                }
                            }
                            
                            getColorScheme(classCode: classData.code) { scheme in
                                if scheme.count != 0 {
                                    if scheme.last!.luminance > 0.8 {
                                        useDefaults = true
                                    }
                                    
                                    colors = scheme
                                }
                            }
                            
                            getClassInfo(classCloudCode: classData.code) { classroom in
                                if let classroom = classroom {
                                    title = classroom.title
                                }
                            }
                            
                            getTasks(classCode: classData.code) { newTasks in
                                tasks = newTasks
                                
                                for classTask in newTasks {
                                    allComponents.append(ClassComponent.classTask(classTask))
                                }
                            }
                            
                            getAnnouncements(classCode: classData.code) { newAnnouncements in
                                announcements = newAnnouncements
                                
                                for announcement in newAnnouncements {
                                    allComponents.append(ClassComponent.announcement(announcement))
                                }
                            }
                            
                            getManagerList(classCode: classData.code) { managers in
                                for email in managers {
                                    getData(uid: email) { manager in
                                        managerNames[email] = manager!.displayName!
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            allComponents.sort { $0.dateCreated > $1.dateCreated }
                            loading = false
                        }
                    }
            } else {
                ScrollView {
                    VStack {
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
                            )
                        
                        // include way to make announcements
                        AnnouncementField(colors: colors, refresh: $loading)
                        
                        if !allComponents.isEmpty {
                            ForEach(allComponents, id: \.self) { component in
                                Text("")
                                
                                ClassComponentView(classCode: classData.code, colors: colors, creator: component.creator, creatorName: managerNames[component.creator]!, title: component.title, message: component.message, date: component.dueDate, timeMade: component.dateCreated, size: component.maxSize, signedUp: component.listOfPeople, numHours: component.numHours, isTask: component.isTask)
                            }
                        } else {
                            Text("Nothing to Display")
                                .padding(.vertical, 10.0)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            settingsManager.manTab = 0
                            settingsManager.title = "Classes"
                        } label: {
                            HStack(spacing: 2.5) {
                                Image(systemName: "chevron.left")
                                
                                
                                Text("Back")
                                
                            }
                            .foregroundStyle(useDefaults ? .green6 : colors.last!)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showMenu = true
                            
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(useDefaults ? .green6 : colors.last!)
                        }
                    }
                }
                .sheet(isPresented: $showMenu) {
                    menuPopUp(classCode: classData.code, showMenu: $showMenu, showPplList: $showPplList, showImageSelection: $showImageSelection, showTask: $showTask, showColorPalette: $showColorPalette)
                        .presentationDetents([.height(240.0)])
                }
                .sheet(isPresented: $showPplList) {
                    StudentPeopleView(code: classData.code, classTitle: title, isShowing: $showPplList)
                        .onDisappear() {
                            showPplList = false
                        }
                }
                .sheet(isPresented: $showImageSelection) {
                    ImagePicker(image: $newHomeImage)
                        .onDisappear() {
                            showImageSelection = false
                            loading = true
                        }
                        .ignoresSafeArea(edges: .bottom)
                }
                .sheet(isPresented: $showTask) {
                    taskPopUp(showTask: $showTask)
                }
                .sheet(isPresented: $showColorPalette) {
                    ColorPalette(showPop: $showColorPalette)
                        .animation(.easeInOut, value: showColorPalette)
                        .onDisappear() {
                            showColorPalette = false
                        }
                }
                .onChange(of: newHomeImage) {
                    if let newHomeImage = newHomeImage {
                        uploadImageToClassroomStorage(code: classData.code, image: newHomeImage, file: "Home\(settingsManager.title)")
                    }
                }
                .animation(.easeIn, value: loading)
            }
        }
}

private struct menuPopUp: View {
    
    var classCode: String
    @Binding var showMenu: Bool
    @Binding var showPplList: Bool
    @Binding var showImageSelection: Bool
    @Binding var showTask: Bool
    @Binding var showColorPalette: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                showMenu = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showPplList = true
                }
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0.0)
                        .contentShape(Rectangle())
                    Text("People")
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            Button {
                showMenu = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showTask = true
                }
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0.0)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                    
                    Text("Create Task")
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            Button {
                showMenu = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showImageSelection = true
                }
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0.0)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                    
                    Text("Select Class Image")
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
            
            Button {
                showMenu = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    showColorPalette = true
                }
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0.0)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                    
                    Text("Pick Class Colors")
                }
                
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

private struct taskPopUp: View {
    
    
    @Binding var showTask: Bool
    
    var body: some View {
        VStack {
            
        }
    }
}
