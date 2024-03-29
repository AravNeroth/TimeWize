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
    @State var allClasses: [Classroom] = []
    @State var classColors: [Classroom:[Color]] = [:]
    @State var classOwners: [Classroom:String] = [:]
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @State var classCodes: [String] = [""]
    @State var done: Bool = false
    @AppStorage("authuid") var authUID = ""
    
    var body: some View {
        if !done {
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    getCodes(uid: userID) { codes in
                        if var codes = codes {
                            while codes.contains("") {
                                let remove = codes.firstIndex(of: "")
                                if let index = remove {
                                    codes.remove(at: index)
                                }
                            }
                            
                            classCodes = codes
                        }
                        
                        loadClassInfo(images: classInfoManager.classImages) { completed in
                            if completed {
                                settingsManager.studentFresh = false
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        for classCode in classCodes {
                            getClassInfo(classCloudCode: classCode) { newClass in
                                let list = newClass?.managerList
                                
                                if let list = list {
                                    getData(uid: list.first!) { newUser in
                                        classOwners[newClass!] = (newUser?.displayName)!
                                    }
                                }
                                
                                getColorScheme(classCode: classCode) { scheme in
                                    classColors[newClass!] = scheme
                                }
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
                        done = true
                    }
                }
                .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
        } else {
            NavigationStack{
                VStack(spacing: 0) {
                    ScrollView {
                        if allClasses.isEmpty {
                            Text("No Classes")
                        } else {
                            ForEach(allClasses, id: \.self) { classroom in
//                                OldClassTabView(name: classroom.title, classCode: classroom.code, banner: classInfoManager.classImages[classroom.title], pfp: classInfoManager.classPfp[classroom.title], allClasses: $allClasses, classroom: classroom)
                                
                                NewClassTabView(title: classroom.title, classCode: classroom.code, colors: classColors[classroom] ?? [.green4, .green6], owner: classOwners[classroom] ?? "", ownerPfp: classInfoManager.classPfp[classroom.title], allClasses: $allClasses, classroom: classroom)
                            }
                        }
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
                                                done = true
                                                settingsManager.studentFresh = false
                                            }
                                        } else {
                                            done = true
                                          
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
//                        Image(systemName: "plus")
//                            .foregroundStyle(.green6)
                    }
                }
            }
            .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
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
                    if !allClasses.contains(classroom) {
                        allClasses.append(classroom)
                    }
                }
                
                classInfoManager.classInfo.sort { $0.title < $1.title }
                allClasses.sort { $0.title < $1.title }
            }
        }
    
        completion(true)
    }
}
