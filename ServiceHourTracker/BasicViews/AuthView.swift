//
//  Auth.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/18/24.
//
import Foundation
import SwiftUI
import FirebaseAuth

enum Views {
    case LoginView
    case StudentView
    case ClassMode
    case ManagerView
//    case ManagerClass
}



struct AuthView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var currentView: Views = .LoginView
    @State private var tabSelection = 2
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @AppStorage("authuid") var authUID = ""
    @State private var isLoaded = false
    var body: some View {
        if isLoaded{
            VStack {
                switch currentView {
                    
                case .LoginView:
                    LoginView()
                case .StudentView:
                    StudentView()
                case .ClassMode:
                    StudentClassroomView().toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            bottomPicks(selection: $tabSelection)
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            
                            LinearGradient(gradient: Gradient(colors: settingsManager.userColors) , startPoint: .topLeading, endPoint: .bottomTrailing).mask(
                                Image(systemName: "plus")
                            ).frame(width: 25, height: 25)
                            
                        }
                    }
                case .ManagerView:
                    ManagerView()
                    
                    //                case .ManagerClass:
                    //                    ManagerClass(loaded: .constant(true))
                }
            }
            .onAppear {
                
                if isLoggedIn() {
                    if(settingsManager.isManagerMode){
                        currentView = .ManagerView
                    }else{
                        currentView = .StudentView
                    }
                } else {
                    currentView = .LoginView
                }
                
                
            }.onChange(of: userID) { oldValue, newValue in
                if isLoggedIn() {
                    currentView = .StudentView
                    loadData()
                } else {
                    clearAppStorageAndObjects()
                    isLoaded = false
                    currentView = .LoginView
                }
            }
            .onChange(of: settingsManager.inClass) { oldValue, newValue in
                if settingsManager.inClass{
                    currentView = .ClassMode
                }else{
                    currentView = .StudentView
                }
            }
            .onChange(of: settingsManager.isManagerMode) { oldValue, newValue in
                if newValue == false{
                    //student mode
                    currentView = .StudentView
                }else{
                    //manager mode
                    currentView = .ManagerView
                }
            }
        }else{
            if isLoggedIn(){
                LoadingScreen()
                    .onAppear(){
                        loadData { result in
                            switch result{
                            case .success():
                                isLoaded = true
                            case.failure(let error):
                                print("failed to load \(error.localizedDescription)")
                            }
                        }
                    }
            }else{
                LoadingScreen().onAppear(){
                    isLoaded = true
                    currentView = .LoginView
                }
            }
            
        }
    }
    private func clearAppStorageAndObjects(){
        //not including the darkmode
        SettingsManager.shared = SettingsManager()
        settingsManager.pfp = UIImage()
        settingsManager.perfHourRange = 20
        settingsManager.title = "Login"
        settingsManager.classes = []
        settingsManager.inClass = false
        classInfoManager.classInfo = []
        classInfoManager.classImages = [:]
        classInfoManager.classPfp = [:]
        classInfoManager.managerClassImages = [:]
        classInfoManager.managerClassPfp = [:]
        @AppStorage("name") var name = ""
        name = ""
        @AppStorage("hours") var hours = 0
        hours = 0
        @AppStorage("authuid") var authID = ""
        authID = ""
        @AppStorage("uid") var userID = ""
        userID = ""
        try? Auth.auth().signOut()
        settingsManager.zeroUserDefaults()
        settingsManager.fresh = true
        settingsManager.studentFresh = true
    }
    private func loadData(completion: ((Result<Void, Error>)-> Void)? = nil){
        
            downloadImageFromUserStorage(id: "\(authUID)", file: "Pfp\(authUID).jpg", completion: { image in
                if let image = image{
                    settingsManager.pfp = image
                }
            })
        
        getUserColors(email: userID) { colors in
            settingsManager.userColors = colors
        }
        if let completion = completion{
            completion(.success(()))
        }
        
    }
    private func isLoggedIn() -> Bool {
        if userID == ""{
            settingsManager.title = "Login"
            return false
        }else{
            
            settingsManager.title = "Classes"
            
            print("\n\n logged in with user id:: \(userID)")
            return true
        }
    }
}

struct Auth_preview: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
