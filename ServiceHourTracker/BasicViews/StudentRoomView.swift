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
    @State var colors: [Color] = [.green4, .green6]
    @State var tasks: [[String: String]] = []
    @State var classImage: UIImage? = UIImage(resource: .image1)
    @State var loading = true
    @State var showMenu = false
    @State var showPplList = false
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    @State private var lastColor:Color = .green6
    var body: some View {
        if loading {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
                    downloadImageFromClassroomStorage(code: "\(classData.code)", file: "Home\(settingsManager.title).jpg", done: $loading) { image in
                        if let image = image {
                            classImage = image
                        }
                        getTasks(classCode: classData.code) { newTasks in
                            tasks = newTasks
                        }
                        getColorScheme(classCode: classData.code) { scheme in
                            colors = scheme
                        }
                        getClassInfo(classCloudCode: classData.code) { classroom in
                            if let classroom = classroom {
                                title = classroom.title
                            }
                        }
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
                                .foregroundStyle((lastColor == .white) || (lastColor == .green6) ? colors[(colors.count)/2] : colors.last ?? .green6)
                            
                            Text("Back")
                                .foregroundStyle((lastColor == .white) || (lastColor == .green6) ? colors[(colors.count)/2] : colors.last ?? .green6)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showMenu.toggle()
                        print("\(colors.last! == Color.white)")
                        print("\(Color.white)")
                        print("\(colors.last! as Color)")
                        print(colorToHex(color: .white))
                        print("\(hexToColor(hex: "\(colors.last! as Color)"))")
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle((lastColor == .white) || (lastColor == .green6) ? colors[(colors.count)/2] : colors.last ?? .green6)
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                menuPopUp(classCode: classData.code, showMenu: $showMenu, showPplList: $showPplList)
                    .presentationDetents([.height(125.0)])
            }
            .sheet(isPresented: $showPplList) {
                PeopleListView(code: classData.code, classTitle: title, isShowing: $showPplList)
            }
            .animation(.easeIn, value: loading)
            .onAppear(){
               lastColor = hexToColor(hex: "\(colors.last! as Color)")
            }
        }
    }
}

private struct menuPopUp: View {
    
    var classCode: String
    @Binding var showMenu: Bool
    @Binding var showPplList: Bool
    
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
                        .foregroundStyle(isDarkModeEnabled() ? .black : .white)
                    
                    Text("People")
                }
            }
            .foregroundStyle(isDarkModeEnabled() ? .white : .black)
            
            Divider()
            
            Button {
                showMenu = false
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(isDarkModeEnabled() ? .black : .white)
                        .ignoresSafeArea()
                    
                    Text("Request Hours")
                }
            }
            .foregroundStyle(isDarkModeEnabled() ? .white : .black)
        }
    }
}



private func isDarkModeEnabled() -> Bool {
    if UITraitCollection.current.userInterfaceStyle == .dark {
        return true
    } else {
        return false
    }
}
