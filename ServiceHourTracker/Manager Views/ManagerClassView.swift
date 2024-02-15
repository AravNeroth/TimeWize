//
//  File.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 2/6/24.
//

import Foundation
import SwiftUI

struct ManagerClassView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State var showJoin = false
    @State var alertField = ""
    @State var enteredCode = ""
    @AppStorage("uid") var userID = ""
    @State var alertMessage = ""
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @State var refreshed = true
//    @State private var classInfo: [Classroom] = []
    @State var classCodes:[String] = [""]
//    @SceneStorage("classInfo") private var classInfo: [Classroom] = []
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
                    .frame(width: 400, height: 50)
                
                ScrollView {
                    if classInfoManager.classInfo.isEmpty{
                        Text("No Classes")
                    }
                    ForEach(classInfoManager.classInfo, id: \.self){ classroom in
                        ClassTabView(name: classroom.title, mainManager: classroom.code, refreshed: $refreshed)
                        
                    }
//                        ClassTabView(name: "Verlyn's Class", mainManager: "Verlyn", tabNum: $settingsManager.tab)
//                        ClassTabView(name: "Parker's Class", mainManager: "Parker", tabNum: $settingsManager.tab)
//                        ClassTabView(name: "Arav's Class", mainManager: "Arav", tabNum: $settingsManager.tab)
//                        ClassTabView(name: "Jonathan's Class", mainManager: "Jonathan", tabNum: $settingsManager.tab)
//                        ClassTabView(name: "Khoa's Class", mainManager: "Khoa", tabNum: $settingsManager.tab)
                    
                }.padding(.bottom, 1)
                
                
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
                .onAppear(){
                    print("classes view")
                    
                    getCodes(uid: userID) { codes in
                        print("in")
                        print("in: \(String(describing: codes))")
                        if var codes = codes{
                            let remove = codes.firstIndex(of: "")
                            print(remove)
                            if let index = remove{
                                codes.remove(at: index)
                                
                            }
                            classCodes = codes
                            
                            
                        }
                        
                        loadClassInfo()
                    }
                  
                    
                   
                }
            }
            
            .background((settingsManager.isDarkModeEnabled) ? Color("green-8") : .white)
            
            
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    showJoin = true
                    alertMessage = "Enter a class Code"
                }label: {
                
                    Image(systemName: "plus")
                
                    
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                
                bottomPicks(selection: $settingsManager.tab)
                
            }
        }
    }
    private func loadClassInfo() {
//        classInfoManager.classInfo.removeAll()
       
  
            for code in classCodes {
                print(code)
                getClassInfo(classCloudCode: code) { classroom in
                    if let classroom = classroom {
                        if !classInfoManager.classInfo.contains(classroom){
                            classInfoManager.classInfo.append(classroom)
                        }
                        
                    }

                    classInfoManager.classInfo.sort { $0.title < $1.title }
                
                }
            }
        }
}

