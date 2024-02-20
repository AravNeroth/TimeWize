//
//  classroomView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/30/24.
//

import SwiftUI

struct ClassroomView: View {
    
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    
    
    
    @State var showReqHours = false
    @State var tasks: [[String: String]] = []
//    @State var taskTitle = ""
//    @State var enteredCode = ""
//    @State var taskDisc = ""
//    @State var hourTypeSelection = 0
//    let hourType = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]

    @State private var showIMGPicker = false
    @State private var selectedImage: UIImage?
    @State private var classImage: UIImage?
    @State private var loading = true
    @AppStorage("authuid") private var authID = ""

    var body: some View {
        if loading{
            LoadingScreen().padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .animation(.easeOut(duration: 2))
                .onAppear(){
                    downloadImageFromClassroomStorage(code: "\(classData.code)", file: "\(settingsManager.title).jpg", done: $loading) { image in
                        if let image = image{
                            classImage = image
                        }
                    }
                }
        } else {
            VStack{
                ScrollView{
                    if let image = classInfoManager.classImages[settingsManager.title]{
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .frame(width: 375, height: 200)
                            
                            Image(uiImage: image).scaledToFill().frame(width: 375, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        }
                    }
                    
                    Divider()
                        .frame(width: 375)
                        .padding(6)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0)
                            .frame(width: 375, height: 75)
                            .foregroundStyle(.green1)
                        Text("\(settingsManager.title) Tasks")
                            .font(.title)
                            .bold()
                            .padding()
                    }
                    Spacer()
                    
                    /*Button{
                        showIMGPicker = true
                    }label:{
                        Text("change the image").padding().clipShape(.capsule).cornerRadius(50).background(.blue).foregroundStyle(.white).padding()
                    }*/
                    
                    if tasks.count != 0 {
                        ForEach(tasks, id:\.self) { task in
                            TaskView(classCode: classData.code, title: "\(task["title"]!)", date: "\(task["date"]!)", totalPpl: Int(task["size"]!) ?? 0)
                        }
                    } else {
                        Text("No Tasks")
                    }
                }
                if showReqHours {
                            Popup(showReqHours: $showReqHours)
                        .frame(width: 300, height: 500, alignment: .center).offset(y: -130)
                        }
                Button{
                    settingsManager.tab = 5
                }label: {
                    Image(systemName: "bell.fill")
                }
                
            }.animation(.easeInOut)
            .fullScreenCover(isPresented: $showIMGPicker) {
                ImagePicker(image: $selectedImage)
                    .ignoresSafeArea(edges: .bottom)
            }.onChange(of: selectedImage) { oldValue, newValue in
                if let image = selectedImage{
                    uploadImageToUserStorage(id: authID, image: selectedImage!,file: settingsManager.title, done: $loading)
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        settingsManager.tab = 2
                    }label: {
                        Image(systemName: "chevron.left").foregroundStyle(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showReqHours = true
                    }label: {
                        Image(systemName: "plus")
                    }
//
                }
            }
            .onDisappear() {
                if let image = classImage {
                    _ = saveImageToDocumentsDirectory(image: image, fileName: "\(settingsManager.title).jpg")
                }
            }.onAppear() {
                getTasks(classCode: classData.code) { newTasks in
                    tasks = newTasks
                }
            }
        }
    }
}
struct Popup: View {
    @Binding var showReqHours: Bool
    @State private var title = ""
    @State private var email = ""
    @State private var hourCount: Double = 0
    @State private var options = ["Attendance", "Service", "Club Specific"]
    @State private var selectedOption = "Attendance Hour"
    @EnvironmentObject private var classData:ClassData
    @AppStorage("uid") private var userID = ""
    var onRequestSubmit: ((_ title: String, _ email: String, _ hourCount: Double, _ selectedOption: String) -> Void)?

    var body: some View {
        VStack(spacing: 20) {
//            TextField("Enter Email", text: $email)
//                .padding()
//                .background(Color.green3).cornerRadius(10)
//                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green6, lineWidth: 2))
//                .padding(.horizontal)
            TextField("Enter Description", text: $title)
                .padding()
                .background(Color.green3).cornerRadius(10)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green6, lineWidth: 2))
                .padding(.horizontal)
            

            Slider(value: $hourCount, in: 0...7, step: 1)
                .padding().tint(Color.green3)
            Text("Hours Requested: \(Int(hourCount))")

            Picker("Select Hour type", selection: $selectedOption) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            .padding()
            .background(Color.green3).cornerRadius(10)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green6, lineWidth: 1))
            .padding(.horizontal)

            HStack {
                Button("Send Request") {
                    showReqHours = false
                    onRequestSubmit?(title, email, hourCount, selectedOption)
                    
                    addRequest(classCode: classData.code, email: userID, hours: Int(hourCount), type: selectedOption, description: title)
                }
                .padding()
                .background(Color.green3)
                .foregroundColor(.green6)
                .cornerRadius(10)

                Button("Cancel") {
                    showReqHours = false
                    title = ""
                    hourCount = 0
                    selectedOption = ""
                }
                .padding()
                .background(Color.green3)
                .foregroundColor(.green6)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.green5)
        .cornerRadius(20, corners: .allCorners)
        .ignoresSafeArea()
    }
}


#Preview {
    ClassroomView()
}
