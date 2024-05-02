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
    @EnvironmentObject var messageManager: MessageManager
    @State var useDefaults = false
    @State var showMessage = false
    var body: some View {
            if loading {
                LoadingScreen()
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ignoresSafeAreaEdges: .all)
                    .onAppear() {
                        let DG = DispatchGroup()
                        DG.enter() //downloadImageFromClassroomStorage
                        DG.enter() //getColorScheme
                        DG.enter() //getClassInfo
                        DG.enter() //getTasks
                        DG.enter() //getAnnouncements
                        DG.enter() //getManagersList
                        allComponents = []
                        
                    
                        downloadImageFromClassroomStorage(code: "\(classData.code)", file: "Home\(settingsManager.title).jpg") { image in
                            if let image = image {
                                classImage = image
                            }
                            DG.leave()
                        }
                        
                        getColorScheme(classCode: classData.code) { scheme in
                            if scheme.count != 0 {
                                if scheme.last!.luminance > 0.8 {
                                    useDefaults = true
                                }
                                
                                colors = scheme
                            }
                            DG.leave()
                        }
                        
                        getClassInfo(classCloudCode: classData.code) { classroom in
                            if let classroom = classroom {
                                title = classroom.title
                            }
                            DG.leave()
                        }
                        
                        getTasks(classCode: classData.code) { newTasks in
                            tasks = newTasks
                            if newTasks.count == 0 {
                                DG.leave()
                            }else{
                                for classTask in newTasks {
                                    allComponents.append(ClassComponent.classTask(classTask))
                                    if classTask == newTasks.last{
                                        DG.leave()
                                    }
                                }
                            }
                        }
                        
                        getAnnouncements(classCode: classData.code) { newAnnouncements in
                            announcements = newAnnouncements
                            
                            if newAnnouncements.count == 0 {
                                DG.leave()
                            }else{
                                for announcement in newAnnouncements {
                                    allComponents.append(ClassComponent.announcement(announcement))
                                    if announcement == newAnnouncements.last{
                                        DG.leave()
                                    }
                                }
                            }
                        }
                        
                        getManagerList(classCode: classData.code) { managers in
                            if managers.count == 0 {
                                DG.leave()
                            }else{
                                for email in managers {
                                    getData(uid: email) { manager in
                                        managerNames[email] = manager!.displayName ?? "No Name"
                                    }
                                    if email == managers.last {
                                        DG.leave()
                                    }
                                }
                            }
                        }
                    
                    
                        DG.notify(queue: .main){
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
                                
                                ClassComponentView(classCode: classData.code, colors: colors, creator: component.creator, creatorName: managerNames[component.creator] ?? "Former Manager", title: component.title, description: component.description, message: component.message, date: component.dueDate, timeMade: component.dateCreated, size: component.maxSize, signedUp: component.listOfPeople, numHours: component.numHours, isTask: component.isTask, fromManagerSide: true)
                            }
                        } else {
                            Text("Nothing to Display")
                                .padding(.vertical, 10.0)
                        }
                    }
                }
                .refreshable{
                    loading = true
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
                    NewManagerPeopleView(showMessage: $showMessage, code: classData.code, classTitle: title, isShowing: $showPplList)
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
                    taskPopUp(classCode: classData.code, colors: colors, reloadPage: $loading, showTask: $showTask)
                }
                .sheet(isPresented: $showColorPalette) {
                    ColorPalette(showPop: $showColorPalette, refresh: $loading, colorsSelected: colors)
                        .animation(.easeInOut, value: showColorPalette)
                        .onDisappear() {
                            showColorPalette = false
                        }
                }
                .sheet(isPresented: $showMessage) {
                    
                    VStack{
                        Text(settingsManager.dm).font(.title).bold()
                        MessageLogView(lastChats: $messageManager.lastMessages , recipientEmail: settingsManager.dm)
                            .padding(.top, 10)
                            .onDisappear {
                                showMessage = false
                            }
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
    
    @State var classCode = ""
    @State var title = ""
    @State var description = ""
    @State var dueDate: Date = Date()
    @State var size: Double = 0
    @State var hourCount: Double = 0
    @State var colors: [Color]
    @Binding var reloadPage: Bool
    @Binding var showTask: Bool
    @AppStorage("uid") var userID = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("New Task")
                    .font(.largeTitle)
                    .bold()
                    .padding(30.0)
                
                Divider()
                    .padding(.horizontal, 30.0)
                    .padding(.bottom, 30.0)
                
                Text("Title")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                TextField("Enter Title", text: $title)
                    .padding()
                    .background(.black.opacity(0.1))
                    .cornerRadius(15.0)
                    .shadow(radius: 2.0, y: 2.0)
                    .padding(.horizontal, 30.0)
                
                Text("")
                    .padding(.vertical, 5.0)
                
                Text("Description")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                TextField("Enter Description", text: $description)
                    .padding()
                    .background(.black.opacity(0.1))
                    .cornerRadius(15.0)
                    .shadow(radius: 2.0, y: 2.0)
                    .padding(.horizontal, 30.0)
                
                Text("")
                    .padding(.vertical, 5.0)
                
                Text("Due Date")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                DatePicker("Due Date:", selection: $dueDate, in: Date()...Calendar.current.date(byAdding: .year, value: 1000, to: Date())!, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .scaleEffect(0.9)
                    .padding(.horizontal, 30.0)
                
                Text("")
                    .padding(.vertical, 5.0)
                
                Text("Number of Hours: \(Int(hourCount))")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                Slider(value: $hourCount, in: 0...10, step: 1)
                    .padding(.horizontal, 30.0)
                    .tint(colors.last!)
                
                Text("")
                    .padding(.vertical, 5.0)
                
                Text("Max Size: \(Int(size))")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                Slider(value: $size, in: 0...20, step: 1)
                    .padding(.horizontal, 30.0)
                    .tint(colors.last!)
                
                Text("")
                    .padding(.vertical, 5.0)
            }
            
            Spacer()
            
            Button {
                if description != "" && size != 0 && hourCount != 0 {
                    addTask(classCode: classCode, creator: userID, title: title, description: description, date: dueDate, timeCreated: Date(), maxSize: Int(size), numHours: Int(hourCount))
                    reloadPage = true
                    showTask = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 60)
                    .padding(.horizontal, 30.0)
                    .overlay(
                        Text("Create Task")
                            .foregroundStyle((colors.first!.luminance > 0.8) ? .black : .white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
    }
}
