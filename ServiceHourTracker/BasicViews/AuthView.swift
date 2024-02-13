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
    //case ManagerViews
}



struct AuthView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var currentView: Views = .LoginView
    @State private var tabSelection = 2
    @EnvironmentObject var settingsManager: SettingsManager
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
                    classroomView().toolbar{
                        ToolbarItem(placement: .bottomBar) {
                            bottomPicks(selection: $tabSelection)
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Image(systemName: "plus")
                        }
                        //                    ToolbarItem(placement: .topBarLeading) {
                        //                        Button{
                        //
                        //                        }label: {
                        //                            Image(systemName: "chevron.left")
                        //                            .font(.title)
                        //                            .foregroundColor(.blue)
                        //                        }
                        //                    }
                    }
                }
            }
            .onAppear {
                
                if isLoggedIn() {
                    currentView = .StudentView
                } else {
                    currentView = .LoginView
                }
                
                
            }.onChange(of: userID) { oldValue, newValue in
                if isLoggedIn() {
                    currentView = .StudentView
                } else {
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
        }else{
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
        }
        
    }
    private func loadData(completion: @escaping (Result<Void, Error>)-> Void){
        if userID == "" || authUID == ""{
            //needs to go to AuthView but done
            completion(.success(()))
        }else{
            
            //the pfp
           
            downloadImageFromUserStorage(id: "\(authUID)", file: "Pfp\(authUID).jpg", completion: { image in
                if let image = image{
                    settingsManager.pfp = image
                }
            })
            
            
            //if nothing bad happened:
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
