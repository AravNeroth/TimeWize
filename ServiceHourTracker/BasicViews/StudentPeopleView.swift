
//  PeopleListView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/22/24.
//

import SwiftUI

struct StudentPeopleView: View {
    
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
    @Binding var showMessage: Bool
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
                    
                    MiniProfileView(showMessageSheet: $showMessage,
                                    showCurrSheet: $isShowing,
                                    userEmail: person,
                                    userPfp: pfpList[person],
                                    username: usernameList[person] ?? "",
                                    personCols: colList[person] ?? [.green4, .green6],
                                    wantedPerson: managerList[0],
                                    loaded: $loaded
                    )
                    
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
                            MiniProfileView(showMessageSheet: $showMessage,
                                            showCurrSheet: $isShowing, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], loaded: $loaded)
                        }
                    }
                }
            }
    } else {
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    let DG = DispatchGroup()
                    DG.enter() //getPeopleList
                    
                    DG.enter()//for loop
                    
                    DG.enter()//managerForLoop
                    DG.enter()//managerList
                    getPeopleList(classCode: code) { newList in
                        defer{DG.leave()}//getPeopleList
                        peopleList = newList
                       
                        
                        
                        
                        if newList.count == 0{
                            print("\nnewListCount is 0\n")
                            DG.leave() //forLoop
                        }else{
                            for personEmail in newList {
                                DG.enter()//getData
                                getData(uid: personEmail) { user in
                                    
                                    if let user = user {
                                        DG.enter() //colors
                                        DG.enter() //image
                                        defer{ DG.leave() } //getData
                                        getUserColors(email: personEmail) { colors in
                                            if !colors.isEmpty {
                                                colList[personEmail] = colors
                                            }
                                            DG.leave() //colors
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
                                if personEmail == newList.last{
                                    DG.leave() //forloop
                                }
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

//MARK: OLD Version Without Mini Profile
/*


struct PeopleListView: View {
    
    @AppStorage("uid") var userID = ""
    @State var code: String
    @State var classTitle: String = ""
    @State var peopleList: [String] = []
    @Binding var isShowing: Bool
    @State private var peopleToPfp:[String:UIImage] = [:]
    @State private var loaded = false
    var body: some View {
        if loaded {
            VStack {
                Text("List of People in \(classTitle)")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                    .frame(width: 350, alignment: .center).padding(.top, 40)
                
                Divider()
                    .padding(30)
                    .frame(width: 350)
                ScrollView{
                    ForEach(peopleList, id: \.self) { person in
                        HStack {
                            Text("\(person)").font(.headline)
                                .bold().padding()
                            Spacer()
                            if let pfp = peopleToPfp[person]{
                                Image(uiImage: pfp).resizable().clipShape(Circle()).frame(width: 30, height: 30).padding(.trailing).shadow(radius: 2.0,y:2.0)
                            }else{
                                Image(systemName: "person").resizable().clipShape(Circle()).frame(width: 30, height: 30).padding(.trailing).shadow(radius: 2.0,y:2.0)
                            }
                        }
                        Divider()
                    }
                }
            }
        }else{
            LoadingScreen().ignoresSafeArea(.all)
            .onAppear() {
                getPeopleList(classCode: code) { people in
                    peopleList = people
                    for personEmail in people {
                        getData(uid: personEmail) { User in
                            if let User = User{
                                downloadImageFromUserStorage(id: User.uid, file: "Pfp\(User.uid).jpg") { pfp in
                                    if let pfp = pfp{
                                        peopleToPfp[personEmail] = pfp
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                        loaded = true
                    }
                }
                
                
            }
        }
    }
}

*/
