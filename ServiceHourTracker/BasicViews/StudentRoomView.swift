//
//  NewStudentRoomView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/1/24.
//

import SwiftUI

struct StudentRoomView: View {
    
    @AppStorage("uid") var userID = ""
    @State var title: String = "Title"
    @State var colors: [Color] = [.green4, .green6] // keep last as green6 for default purpouses
    @State var tasks: [ClassTask] = []
    @State var announcements: [Announcement] = []
    @State var allComponents: [ClassComponent] = []
    @State var managerNames: [String:String] = [:]
    @State var classImage: UIImage? = UIImage(resource: .image1)
    @State var loading = true
    @State var showMenu = false
    @State var showPplList = false
    @State var showRequest = false
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
                                    managerNames[email] = manager!.displayName!
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
                    
                    if !allComponents.isEmpty {
                        ForEach(allComponents, id: \.self) { component in
                            Text("")
                            
                            ClassComponentView(classCode: classData.code, colors: colors, creator: component.creator, creatorName: managerNames[component.creator] ?? "Former Manager", title: component.title, description: component.description, message: component.message, date: component.dueDate, timeMade: component.dateCreated, size: component.maxSize, signedUp: component.listOfPeople, numHours: component.numHours, isTask: component.isTask)
                        }
                    } else {
                        Text("Nothing to Display")
                            .padding(.vertical, 10.0)
                    }
                }
            }
            .refreshable {
                loading = true
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        settingsManager.tab = 2
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
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(useDefaults ? .green6 : colors.last!)
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                menuPopUp(classCode: classData.code, showMenu: $showMenu, showPplList: $showPplList, showRequest: $showRequest)
                    .presentationDetents([.height(120.0)])
            }
            .sheet(isPresented: $showPplList) {
                StudentPeopleView(code: classData.code, classTitle: title, isShowing: $showPplList, showMessage: $showMessage)
                    .onDisappear {
                        showPplList = false
                    }
            }
            .sheet(isPresented: $showMessage) {
                
                    
                MessageLogView(lastChats: $messageManager.lastMessages , recipientEmail: settingsManager.dm)
                    .padding(.top, 10)
                    .onDisappear {
                        showMessage = false
                    }
                
            }
            .sheet(isPresented: $showRequest) {
                requestPopUp(colors: colors, isShowing: $showRequest)
                    .ignoresSafeArea(.keyboard)
                    .onDisappear {
                        showRequest = false
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
    @Binding var showRequest: Bool
    
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
                    showRequest = true
                }
            } label: {
                ZStack {
                    Rectangle()
                        .opacity(0.0)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                    
                    Text("Request Hours")
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            
        }
    }
}

private struct requestPopUp: View {
    
    @AppStorage("uid") var userID = ""
    @State var title = ""
    @State var description = ""
    @State var hourCount: Double = 0
    @State var selected = "Attendance"
    @State var verifier = ""
    var colors: [Color]
    var options = ["Attendance", "Service", "Club Specific"]
    @EnvironmentObject private var classData: ClassData
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("New Request")
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
                
                Text("Reference Person")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                TextField("Enter Reference", text: $verifier)
                    .padding()
                    .background(.black.opacity(0.1))
                    .cornerRadius(15.0)
                    .shadow(radius: 2.0, y: 2.0)
                    .padding(.horizontal, 30.0)
                
                Text("")
                    .padding(.vertical, 5.0)
                
                Text("Type of Hour")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                Picker("Select Hour Type", selection: $selected) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 30.0)
                
                Text("")
                    .padding(.vertical, 5.0)
                
                Text("Requested Hours: \(Int(hourCount))")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 30.0)
                
                Slider(value: $hourCount, in: 0...10, step: 1)
                    .padding(30.0)
                    .tint(colors.last!)
            }
            
            Spacer()
            
            Button {
                if description != "" && hourCount != 0 {
                    addRequest(classCode: classData.code, email: userID, hours: Int(hourCount), type: selected, title: title, description: description, verifier: verifier)
                    isShowing = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 60)
                    .padding(.horizontal, 30.0)
                    .overlay(
                        Text("Send Request")
                            .foregroundStyle((colors.first!.luminance > 0.8) ? .black : .white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 10.0)
            
            Spacer()
        }
    }
}

enum ClassComponent: Hashable {
    case classTask(ClassTask)
    case announcement(Announcement)
    
    var creator: String {
        switch self {
            case .classTask(let classTask):
                return classTask.creator
            case .announcement(let announcement):
                return announcement.creator
        }
    }
    
    var title: String {
        switch self {
            case .classTask(let classTask):
                return classTask.title
            case .announcement(_):
                return ""
        }
    }
    
    var description: String {
        switch self {
            case .classTask(let classTask):
                return classTask.description
            case .announcement(_):
                return ""
        }
    }
    
    var dateCreated: Date {
        switch self {
            case .classTask(let classTask):
                return classTask.timeCreated
            case .announcement(let announcement):
                return announcement.date
        }
    }
    
    var dueDate: Date {
        switch self {
            case .classTask(let classTask):
                return classTask.date
            case .announcement(_):
                return Date()
        }
    }
    
    var message: String {
        switch self {
            case .classTask(_):
                return ""
            case .announcement(let announcement):
                return announcement.message
        }
    }
    
    var listOfPeople: [String] {
        switch self {
            case .classTask(let classTask):
                return classTask.listOfPeople ?? []
            case .announcement(_):
                return []
        }
    }
    
    var maxSize: Int {
        switch self {
            case .classTask(let classTask):
                return classTask.maxSize
            case .announcement(_):
                return 0
        }
    }
    
    var numHours: Int {
        switch self {
            case .classTask(let classTask):
                return classTask.numHours
            case .announcement(_):
                return 0
        }
    }
    
    var isTask: Bool {
        switch self {
            case .classTask(_):
                return true
            case .announcement(_):
                return false
        }
    }
}
