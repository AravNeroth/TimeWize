
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
