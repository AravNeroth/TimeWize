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
    @State var colors: [Color] = [.green4, .green6] //keep last as green6 for default purpouses 
    @State var tasks: [[String: String]] = []
    @State var classImage: UIImage? = UIImage(resource: .image1)
    @State var loading = true
    @State var showMenu = false
    @State var showPplList = false
    @State var showRequest = false
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    @State private var lastColor:Color = .green6
    @State private var testColor:Color = .green6
    @State var useDefaults = false
    var body: some View {
        if loading {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
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
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        loading = false
                                    }
                                }
                            }
                        }
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
                    
                    if tasks.count != 0 {
                        ForEach(tasks, id:\.self) { task in
                            TaskView(classCode: classData.code, title: "\(task["title"] ?? "No Title")", date: "\(task["date"] ?? "0/0/0000")", totalPpl: Int(task["size"] ?? "0")!, numHours: Int(task["hours"] ?? "0")!)
                        }
                    } else {
                        Text("No Tasks")
                            .padding(.vertical, 10.0)
                    }
                }
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
                        showMenu.toggle()

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
                StudentPeopleView(code: classData.code, classTitle: title, isShowing: $showPplList)
            }
            .sheet(isPresented: $showRequest) {
                requestPopUp(colors: colors, isShowing: $showRequest)
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
    @State var description = ""
    @State var hourCount: Double = 0
    @State var selected = "Attendance"
    var colors: [Color]
    var options = ["Attendance", "Service", "Club Specific"]
    @EnvironmentObject private var classData: ClassData
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("New Request")
                .font(.largeTitle)
                .bold()
                .padding(30.0)
            
            Divider()
                .padding(.horizontal, 30.0)
                .padding(.bottom, 30.0)
            
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
                .padding(.horizontal, 30.0)
                .tint(colors.last!)
        }
        
        Spacer()
        
        Button {
            addRequest(classCode: classData.code, email: userID, hours: Int(hourCount), type: selected, description: description)
            isShowing = false
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
        
        Spacer()
    }
}
