//
//  NewManagerPeopleView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/14/24.
//

import SwiftUI

struct NewManagerPeopleView: View {
    
    @AppStorage("uid") var userID = ""
    @State var code: String
    @State var classOwner: String = ""
    @State var classTitle: String = ""
    @State var peopleList: [String] = []
    @State var managerList: [String] = []
    @State var pfpList: [String:UIImage] = [:]
    @State var usernameList: [String:String] = [:]
    @State var colList: [String:[Color]] = [:]
    @Binding var isShowing: Bool
    @State private var loaded = false
    
    var body: some View {
        if loaded {
            VStack {
                Text("\(classTitle)")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                    .frame(width: 250, alignment: .center)
                    .padding(.top, 40)
                
                Divider()
                    .padding(.vertical, 5.0)
                
                Text("Managers")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .bold()
                
                Divider()
                    .padding(.vertical, 5.0)
                
                ForEach(managerList, id: \.self) { person in
                    MiniProfileView(classCode: code, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], wantedPerson: managerList[0], fromManView: true, isManager: true, loaded: $loaded)
                }
                
                Divider()
                    .padding(.top, 10.0)
                    .padding(.bottom, 5.0)
                
                Text("Students")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .bold()
                
                
                ZStack(alignment: .top) {
                    Divider()
                        .frame(height: 1)
                    
                    ScrollView {
                        Text("")
                        
                        ForEach(peopleList, id: \.self) { person in
                            MiniProfileView(classCode: code, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], fromManView: true, loaded: $loaded)
                        }
                    }
                }
            }
    } else {
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    getPeopleList(classCode: code) { newList in
                        peopleList = newList
                       
                        getManagerList(classCode: code) { managers in
                                managerList = managers
                                classOwner = managerList[0]
                            }
                        
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
