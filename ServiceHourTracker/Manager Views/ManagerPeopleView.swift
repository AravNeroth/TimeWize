//
//  ManagerPeopleListView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 2/29/24.
//

import Foundation
import SwiftUI

struct ManagerPeopleView: View {
    
    @AppStorage("uid") var userID = ""
    @State var code: String = ""
    @State var classOwner: String = ""
    @State var classTitle: String = ""
    @State var peopleList: [String] = []
    @State var managerList: [String] = []
    @State var pfpList: [String:UIImage] = [:]
    @State var usernameList: [String:String] = [:]
    @State var colList: [String:[Color]] = [:]
    @Binding var isShowing: Bool
    @State private var editing: Bool = false
    @State private var loaded: Bool = false
    @State private var isOwner: Bool = false
    @State private var peopleToPfp:[String:UIImage] = [:]
    @Binding var showMessage: Bool
    var body: some View {
        
        if !loaded {
            LoadingScreen()
                .ignoresSafeArea(.all)
                .onAppear() {
                    
                    isClassOwner(classCode: code, uid: userID) { result in
                            self.isOwner = result
                            }
                    
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
                    
                    getManagerList(classCode: code) { managers in
                        managerList = managers
                        for manager in managers {
                            getData(uid: manager) { user in
                                if let user = user {
                                    getUserColors(email: manager) { colors in
                                        if !colors.isEmpty {
                                            colList[manager] = colors
                                        }
                                        
                                        usernameList[manager] = user.displayName ?? "No Name"
                                        
                                        downloadImageFromUserStorage(id: user.uid, file: "Pfp\(user.uid).jpg") { pfp in
                                            if let pfp = pfp {
                                                pfpList[manager] = pfp
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                loaded = true
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                        classOwner = managerList[0]
                        print("Managers:   \(managers)")
                    }
                    
                    

                }
        }else{
            
            
            VStack {
                Text("People in \(classTitle)")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                    .frame(width: 250, alignment: .center)
                    .padding(.top, 40)
                
                
                Divider()
                
                Text("Managers")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .bold()
            }
            
            ScrollView {
                
                
                if editing {
                    ForEach(managerList, id: \.self) { person in
                        HStack {
                            MiniProfileView(showMessageSheet: $showMessage, showCurrSheet: $isShowing, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], wantedPerson: managerList[0], loaded: $loaded)
                            Spacer()
                            
                            
                            
                            // if you are not the owner, or if u are the owner but u have a diff username to owner,
                            // you can demote students
                            // if you ARE the owner, you can demote and remove, but not remove or demote urself
                            if (!isOwner || (isOwner && person != userID)) {
                                Button(action: {
                                    unenrollClass(uid: person, code: code)
                                    demoteManager(person: person, classCode: code)
                                    withAnimation {
                                        managerList.removeAll(where: { $0 == person })
                                    }
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                        }
                    }.onDelete { indexSet in
                        indexSet.forEach { index in
                            let person = peopleList[index]
                            demoteManager(person: person, classCode: code)
                        }
                        withAnimation {
                            managerList.remove(atOffsets: indexSet)
                        }
                    }
                } else {
                    ForEach(managerList, id: \.self) { person in
                        
                        HStack {
                            MiniProfileView(showMessageSheet: $showMessage, showCurrSheet: $isShowing, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], wantedPerson: managerList[0], loaded: $loaded)
                            Spacer()
                        }
                    }
                }
            
            
            
            
            
            // students displayed
            VStack{
                
                Text("Students")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .bold()
                    .frame(width: 250, alignment: .center)
                    .padding(.top, 18)
            }
            
            VStack{
                HStack{
                    Spacer()
                    Button{
                        editing.toggle()
                    }label: {
                        Image(systemName: editing ? "checkmark.rectangle.stack" : "square.and.pencil").resizable().frame(width: 20,height: 20).padding(.trailing, 13).padding(.bottom, 2).animation(.smooth(duration: 0.65), value: editing)
                    }
                }
                
                if editing{
                    ForEach(peopleList, id: \.self) { person in
                        
                        HStack {
                            MiniProfileView(showMessageSheet: $showMessage, showCurrSheet: $isShowing, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], wantedPerson: managerList[0], loaded: $loaded)
                            
                            Spacer()
                            Button(action: {
                                unenrollClass(uid: person, code: code)
                                removePersonFromClass(person: person, classCode: code)
                                withAnimation {
                                    peopleList.removeAll(where: { $0 == person })
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }.onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            let person = peopleList[index]
                            removePersonFromClass(person: person, classCode: code)
                        }
                        
                        withAnimation {
                            peopleList.remove(atOffsets: indexSet)
                        }
                    }
                }else{
                    ForEach(peopleList, id: \.self) { person in
                        
                        
                        HStack {
                            MiniProfileView(showMessageSheet: $showMessage, showCurrSheet: $isShowing, userEmail: person, userPfp: pfpList[person], username: usernameList[person] ?? "", personCols: colList[person] ?? [.green4, .green6], wantedPerson: managerList[0], loaded: $loaded)
                            Spacer()
                        }
                    }
                }
            }
        }
            // end of V stack below "Students" text
                .padding(.top, 10)
                
            }
        }
    }

