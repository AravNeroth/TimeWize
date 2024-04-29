//
//  NewManagerPeopleView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/14/24.
//

import SwiftUI

struct NewManagerPeopleView: View {
    @Binding var showMessage: Bool
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
                    MiniProfileView(showMessageSheet: $showMessage, showCurrSheet: $isShowing, classCode: code, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], wantedPerson: managerList[0], loaded: $loaded)
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
                            MiniProfileView(showMessageSheet: $showMessage, showCurrSheet: $isShowing, classCode: code, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], fromManView: true, loaded: $loaded)
                        }
                    }
                }
            }
    } else {
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    let DG = DispatchGroup()
                    DG.enter() // for loop
                    DG.enter() //peopleList
                    
                    DG.enter()//managerForLoop
                    DG.enter()//managerList
                    
                    //MARK: People
                    getPeopleList(classCode: code) { newList in
                        defer{ DG.leave() }
                        peopleList = newList
                        
                        for personEmail in newList {
                            DG.enter() //getData'
                            
                            getData(uid: personEmail) { user in
                                if let user = user {
                                    DG.enter() //userColors
                                    DG.enter() // userImage
                                    defer{ DG.leave() /*getData*/}
                                    getUserColors(email: personEmail) { colors in
                                        if !colors.isEmpty {
                                            colList[personEmail] = colors
                                        }
                                        DG.leave() //userColors
                                        
                                    }
                                    usernameList[personEmail] = user.displayName ?? "No Name"
                                    
                                    downloadImageFromUserStorage(id: user.uid, file: "Pfp\(user.uid).jpg") { pfp in
                                        if let pfp = pfp {
                                            pfpList[personEmail] = pfp
                                        }
                                        DG.leave() //image
                                    }
                                    
                                }else{
                                    DG.leave() //getData
                                }
                            }
                            if personEmail == newList.last {
                                DG.leave() // for loop
                            }
                        }
                        
                        
                    }
                    
                    getManagerList(classCode: code) { managers in
                        if managers != [] {
                            managerList = managers
                            classOwner = managerList[0]
                        }
                        DG.leave() //managerList
                       
                        if managerList.count == 0{
                            DG.leave() //forloop
                        }else{
                            
                            for manEmail in managerList {
                                
                                DG.enter() //colors
                                DG.enter() //image
                                DG.enter() //getData
                                
                                getUserColors(email: manEmail) { colors in
                                    if !colors.isEmpty {
                                        colList[manEmail] = colors
                                    }
                                
                                    DG.leave() //colors
                                    
                                }
                                
                                getData(uid: manEmail) { user in
                                    defer{DG.leave()}//getData
                                    
                                    if let user = user {
                                        
                                        usernameList[manEmail] = user.displayName ?? "No Name"
                                        
                                        downloadImageFromUserStorage(id: user.uid, file: "Pfp\(user.uid).jpg") { pfp in
                                            if let pfp = pfp {
                                                pfpList[manEmail] = pfp
                                            }
                                            
                                            DG.leave() //image
                                            
                                        }
                                        
                                    }else{
                                        DG.leave() //image
                                    }
                                }
                                if manEmail == managerList.last{
                                    DG.leave() //for Loop
                                }
                            }
                        }
                        
                    }
                    
                    DG.notify(queue: .main) {
                        loaded = true
                    }
                }
        }
    }
}
