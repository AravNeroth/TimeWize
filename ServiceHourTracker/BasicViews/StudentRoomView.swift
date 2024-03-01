//
//  NewStudentRoomView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/1/24.
//

import SwiftUI

struct StudentRoomView: View {
    
    @AppStorage("uid") var userID = ""
    var title: String = "Title"
    var classCode: String = ""
    @State var colors: [Color] = [.green2, .green4]
    @State var tasks: [[String: String]] = []
    @State var classImage: UIImage? = UIImage(resource: .image1)
    @State var loading = true
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    
    var body: some View {
        if loading {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
                    downloadImageFromClassroomStorage(code: "\(classData.code)", file: "\(settingsManager.title).jpg", done: $loading) { image in
                        if let image = image {
                            classImage = image
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
                    }
                }
            }
            .animation(.easeIn, value: loading)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        settingsManager.tab = 2
                        settingsManager.title = "Classes"
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colors.last ?? .green4)
                    }
                }
            }
            .onAppear() {
                getTasks(classCode: classData.code) { newTasks in
                    tasks = newTasks
                }
            }
        }
    }
}
