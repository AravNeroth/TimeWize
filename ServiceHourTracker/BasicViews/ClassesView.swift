//
//  ContentView.swift
//  ServiceHourTracker
//
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct ClassesView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State var showJoin = false
    @State var alertField = ""
    @State var enteredCode = ""
    @AppStorage("uid") var userID = ""
    @State var alertMessage = ""
    @EnvironmentObject var classInfoManager: ClassInfoManager

    @State var classCodes:[String] = [""]

    @State private var done = false
    @AppStorage("authuid") var authUID = ""
    

    var body: some View {
        if done != true{
            LoadingScreen()
                
                .animation(.easeInOut)
                .onAppear(){
                        print("classes view")
                        
                        getCodes(uid: userID) { codes in
//                            print("in")
//                            print("in: \(String(describing: codes))")
                            
                            if var codes = codes{
                                while codes.contains(""){
                                    
                                    
                                    let remove = codes.firstIndex(of: "")
                                    
                                    if let index = remove{
                                        codes.remove(at: index)
                                        
                                    }
                                }
                                    classCodes = codes
                                    
                                
                            }
//                         ]
                            loadClassInfo(images: classInfoManager.classImages){ completed in
                                if completed {
                                    self.done = true
                                }
                                
                            }
                        }
                        
                        
                        
                    }
                .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
                
        }else{
            NavigationStack{
                VStack(spacing: 0) {
//                    Rectangle()
//                        .foregroundColor((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
//                        .frame(width: 400, height: 50)
                    
                    ScrollView {
                        if classInfoManager.classInfo.isEmpty {
                            Text("No Classes")
                        } else if done {
                            ForEach(classInfoManager.classInfo) { classroom in
                                ClassTabView(name: classroom.title,
                                             classCode: classroom.code,
                                             banner: classInfoManager.classImages[classroom.title],
                                             pfp: classInfoManager.classPfp[classroom.title],
                                             refreshed: $done)
                                    .animation(.spring(duration: 1))
                                
                            }
                        } else {
                            ForEach(classInfoManager.classInfo) { classroom in
                                ClassTabView(name: classroom.title,
                                             classCode: classroom.code,
                                             banner: classInfoManager.classImages[classroom.title],
                                             pfp: classInfoManager.classPfp[classroom.title],
                                             refreshed: $done)
                                    .animation(.spring(duration: 1))
                                
                            }
                        }
                        
                    }.padding(.bottom, 7).padding(.top, 7)
                    
                    
                        .alert("Class Code", isPresented: $showJoin) {
                            TextField("code", text: $alertField).foregroundColor(.black)
                            Button("OK") {
                                enteredCode = alertField
                                alertField = ""
                            }
                            Button("Cancel"){
                                
                            }
                        } message: {
                            Text(alertMessage)
                        }
                        .onChange(of: enteredCode) { oldValue, newValue in
                            checkIfDocumentExists(documentID: enteredCode){result in
                                if result{
                                    print("\n exists \n ")
                                    updateCodes(uid: userID, newCode: enteredCode)
                                    settingsManager.tab = 4
                                    currentView = .classroomView
                                    settingsManager.title = "Welcome"
                                }else{
                                    print("\n does not exist \n ")
                                    alertMessage = "The code is wrong"
                                    showJoin = true
                                    
                                }
                            }
                            
                            
                        }
                        
                }
                
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        showJoin = true
                        alertMessage = "Enter a class Code"
                    }label: {
                    
                        Image(systemName: "plus").foregroundStyle(.green5)
                    
                        
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    
                    bottomPicks(selection: $settingsManager.tab)
                    
                }
            }
            
            .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
        }//end of else
            

 
            
            
    }
    private func loadClassInfo(images: [String:UIImage], completion: @escaping (Bool) -> Void) {
//        classInfoManager.classInfo.removeAll()
       
  
            for code in classCodes {
                print(code)
                getClassInfo(classCloudCode: code) { classroom in
                    if let classroom = classroom {
                        if !classInfoManager.classInfo.contains(classroom){
                            classInfoManager.classInfo.append(classroom)
                            
                            downloadImageFromClassroomStorage(code: code, file: "\(classroom.title).jpg", completion: { image in
                                 classInfoManager.classImages[classroom.title] = image
                            })
                            
                            print("\n looking for Pfp\(classroom.owner).jpg \n")
                            
                            
                            downloadImageFromUserStorage(id: "\(classroom.owner)", file: "Pfp\(classroom.owner).jpg") {
                                    
                                    image in
                                    if let image = image{
                                        print("found \(code)")
                                        classInfoManager.classPfp[classroom.title] = image
                                    }else{
                                        print("no pfp for class with code \(code) and name \(classroom.title)")
                                    }
                                }
                                
                            
                            
                            
                        }
                        
                    }

                    classInfoManager.classInfo.sort { $0.title < $1.title }

                }
            }
        completion(true)
        }
}

