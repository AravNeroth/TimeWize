//
//  classroomView.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/30/24.
//

import SwiftUI

struct classroomView: View {
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
                            TaskView(title: "\(task["title"]!)", date: "\(task["date"]!)", currPpl: task["people"]!.count)
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
    @State private var HourCount: Double = 0
    @State private var options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    @State private var selectedOption = ""
    
    

    var body: some View{
        
        VStack(spacing: 20) {
            TextField("Enter Title", text: $title)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green7, lineWidth: 1))
                .padding(.horizontal)
            
            Slider(value: $HourCount, in: 0...20, step: 1)
                            .padding()
            Text("Hours Requested: \(Int(HourCount))")

            Picker("Select Hour type", selection: $selectedOption) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green7, lineWidth: 1))
            .padding(.horizontal)
            HStack{
                Button("Send Request") {
                    showReqHours = false
                    print(title)
                    print(HourCount)
                    print(selectedOption)
                }.padding()
                    .background(Color.blue4)
                    .foregroundColor(.green6)
                    .cornerRadius(10)
                
                Button("Cancel"){
                    showReqHours = false
                    title = ""
                    HourCount = 0
                    selectedOption = ""
                }.padding()
                    .background(Color.blue4)
                    .foregroundColor(.green6)
                    .cornerRadius(10)
            }
            
        }.padding().background(Color.green4).cornerRadius(20, corners: .allCorners)
        
    }
}


#Preview {
    classroomView()
}
