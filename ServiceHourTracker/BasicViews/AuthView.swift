//
//  Auth.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 1/18/24.
//
import Foundation
import SwiftUI

enum Views {
    case LoginView
    case StudentView
}

struct AuthView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var currentView: Views = .LoginView
    
    var body: some View {
       
        VStack {
            switch currentView {
            case .LoginView:
                LoginView()
            case .StudentView:
                StudentView()
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
    }

    private func isLoggedIn() -> Bool {
        if userID == ""{
            return false
        }else{
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
