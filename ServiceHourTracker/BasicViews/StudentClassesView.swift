//
//  ContentView.swift
//  ServiceHourTracker
//
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct StudentClassesView: View {
    
    @EnvironmentObject var settingsManager: SettingsManager
    @State var showJoinMessage = false
    @State var alertField = ""
    @State var enteredCode = ""
    @AppStorage("uid") var userID = ""
    @State var alertMessage = ""
//    @State var allClasses: [Classroom] = []
//    @State var classColors: [Classroom:[Color]] = [:]
//    @State var classOwners: [Classroom:String] = [:]
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @State var classCodes: [String] = [""]
    @State var refresh: Bool = false
    @AppStorage("authuid") var authUID = ""
    @EnvironmentObject var messageManager: MessageManager
    var body: some View {
        
        if classInfoManager.allClasses.isEmpty || classInfoManager.classColors.count < classInfoManager.allClasses.count || refresh {
            
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    
                    classInfoManager.updateData(userID: userID){_ in
                            refresh = false
                    }

                }
                .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
            
            
        } else {
            NavigationStack{
                VStack(spacing: 0) {
                    ScrollView {
                        if classInfoManager.allClasses.isEmpty {
                            Text("No Classes")
                        } else {
                            ForEach(classInfoManager.allClasses, id: \.self) { classroom in
                                
                                NewClassTabView(
                                    title: classroom.title,
                                    classCode: classroom.code,
                                    colors: classInfoManager.classColors[classroom] ?? settingsManager.userColors,
                                    owner: classInfoManager.classOwners[classroom] ?? "",
                                    ownerPfp: classInfoManager.classPfp[classroom.title],
                                    allClasses: $classInfoManager.allClasses, classroom: classroom)
                            }
                        }
                    }.refreshable{

                        refresh = true
                        refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
                    }
                    .padding(.top, 7)
                    .alert("Class Code", isPresented: $showJoinMessage) {
                        TextField("code", text: $alertField).foregroundColor(.black)
                        Button("OK") {
                            enteredCode = alertField
                            alertField = ""
                        }
                        Button("Cancel") { }
                    } message: {
                        Text(alertMessage)
                    }
                    .onChange(of: enteredCode) { oldValue, newValue in
                        checkIfDocumentExists(documentID: enteredCode) { result in
                            if result {
                                updateCodes(uid: userID, newCode: enteredCode)
                                addPersonToClass(person: userID, classCode: enteredCode)
                                loadClassInfo(images: classInfoManager.classImages) { completed in
                                    if completed {
                                        if settingsManager.studentFresh {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ){
                                                refresh = true
                                                settingsManager.studentFresh = false
                                            }
                                        } else {
                                            refresh = true
                                          
                                        }
                                    }
                                }
                            } else {
                                alertMessage = "The code is wrong"
                                showJoinMessage = true
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showJoinMessage = true
                        alertMessage = "Enter a class code"
                    } label: {
                        LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                            Image(systemName: "plus")
                        ).frame(width: 25, height: 25)

                    }
                }
            }
            .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
            .onAppear{
                // add a call to publush to the timer
                refreshVars(messageManager: messageManager, classInfoManager: classInfoManager)
            }
        }
    }

    private func loadClassInfo(images: [String:UIImage], completion: @escaping (Bool) -> Void) {
        for code in classCodes {
            getClassInfo(classCloudCode: code) { classroom in
                if let classroom = classroom {
                    if !classInfoManager.classInfo.contains(classroom) {
                        classInfoManager.classInfo.append(classroom)
                        
                        downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg") { image in
                            classInfoManager.classImages[classroom.title] = image
                        }
                    
                        downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") { image in
                            if let image = image {
                                classInfoManager.classPfp[classroom.title] = image
                            }
                        }
                    }
                    if !classInfoManager.allClasses.contains(classroom) {
                        classInfoManager.allClasses.append(classroom)
                    }
                }
                
                classInfoManager.classInfo.sort { $0.title < $1.title }
                classInfoManager.allClasses.sort { $0.title < $1.title }
            }
        }
    
        completion(true)
    }
}
