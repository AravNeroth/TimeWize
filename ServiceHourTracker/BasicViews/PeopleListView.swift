//
//  PeopleListView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/22/24.
//

import SwiftUI

struct PeopleListView: View {
    
    @State var code: String
    @State var classTitle: String = ""
    @State var peopleList: [String] = []
    @State var pfpList: [String:UIImage] = [:]
    @State var usernameList: [String:String] = [:]
    @State var colList: [String:[Color]] = [:]
    @Binding var isShowing: Bool
    @State private var loaded = false
    
    var body: some View {
        if loaded {
            VStack {
                Text("People in \(classTitle)")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                    .frame(width: 250, alignment: .center)
                    .padding(.top, 40)
                
                ZStack(alignment: .top) {
                    Divider()
                        .frame(height: 1)
                    
                    ScrollView {
                        Text("")
                        
                        ForEach(peopleList, id: \.self) { person in
                            MiniProfileView(userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6])
                        }
                    }
                }
                .padding(.top, 30)
            }
        } else {
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    getPeopleList(classCode: code) { newList in
                        peopleList = newList
                        
                        for personEmail in newList {
                            getData(uid: personEmail) { user in
                                if let user = user {
                                    getUserColors(email: personEmail) { colors in
                                        if !colors.isEmpty {
                                            colList[personEmail] = colors
                                        }
                                        
                                        usernameList[personEmail] = user.displayName ?? "No Name"
                                        
                                        downloadImageFromUserStorage(id: user.uid, file: "Pfp\(user.uid).jpg") { pfp in
                                            if let pfp = pfp {
                                                pfpList[personEmail] = pfp
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                loaded = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}


