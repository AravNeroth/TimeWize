//
//  ClassComponentView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/3/24.
//

import SwiftUI

struct ClassComponentView: View {
    
    @State var classCode: String = ""
    @State var colors: [Color] = [.green4, .green6]
    @State var creator: String = "Creator"
    @State var creatorName: String = "Name"
    @State var title: String = "Test Title"
    @State var message: String = "No Announcement to Display"
    @State var date: Date
    @State var timeMade: Date
    @State var size = 0
    @State var signedUp: [String] = []
    @State var numHours = 0
    @State var isTask = true
    @State var showTaskPopUp = false
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        if isTask {
            Button {
                showTaskPopUp.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.background)
                    .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                    .frame(height: 100)
                    .padding(.horizontal, 10.0)
                    .shadow(radius: 2.0, y: 2.0)
                    .overlay(
                        VStack {
                            HStack {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Image(systemName: "list.clipboard.fill")
                                            .font(.system(size: 25.0, weight: .bold))
                                            .imageScale(.large)
                                            .foregroundStyle((colors.last!.luminance > 0.8) ? .black : .white)
                                            .padding(.bottom, 5.0)
                                    )
                                    .padding(.leading, 20.0)
                                    
                                
                                Text("\(title)")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                VStack {
                                    Text("Sign Up Ends:")
                                        .font(.caption)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30.0)
                                    
                                    Text("\(formatDate(date))")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30.0)
                                }
                            }
                        }
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showTaskPopUp) {
                taskPopUp(title: title, creator: creator, signedUp: signedUp, size: size, numHours: numHours, date: date, isShowing: $showTaskPopUp)
            }
        } else {
            VStack {
                HStack {
                    Text("\(creatorName):")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 30.0)
                        .padding(.vertical, 15.0)
                    
                    Spacer()
                }
                
                HStack {
                    Text(message)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 30.0)
                        .padding(.bottom, 15.0)
                    
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15.0)
                    .stroke(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                    .padding(.horizontal, 10.0)
                    .shadow(radius: 2.0, y: 2.0)
            )
            
        }
            
    }
}

private struct taskPopUp: View {
    
    @State var title = ""
    @State var creator: String = ""
    @State var signedUp: [String] = []
    @State var signedUpNames: [String:String] = [:]
    @State var signedUpColors: [String:[Color]] = [:]
    @State var size = 0
    @State var numHours = 0
    @State var date: Date
    @State var loading = true
    @Binding var isShowing: Bool
    
    var body: some View {
        if loading {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
                    for userEmail in signedUp {
                        getUserColors(email: userEmail) { colors in
                            signedUpColors[userEmail] = colors
                        }
                        getData(uid: userEmail) { user in
                            if let user = user {
                                signedUpNames[userEmail] = user.displayName
                            }
                        }
                    }
                    loading = false
                }
        } else {
            Text("Jus For Testin")
//            taskPopup(showPop: $isShowing).padding(.top)
        }
    }
}
