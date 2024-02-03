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
}



struct AuthView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var currentView: Views = .LoginView
    @State private var tabSelection = 2
    @EnvironmentObject var settingsManager: SettingsManager
//    @AppStorage("pswd") var password = ""
    @AppStorage("authuid") var authUID = ""
    var body: some View {
       
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
