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
    @State var code: String
    @State var classTitle: String = ""
    @State var peopleList: [String] = []
    @State var managerList: [String] = []
    @Binding var isShowing: Bool
    @State private var editing: Bool = false
    @State private var loaded: Bool = false
    @State private var isOwner: Bool = false
    @State private var peopleToPfp:[String:UIImage] = [:]
    
    var body: some View {
        
        if loaded == false{
            LoadingScreen().ignoresSafeArea(.all)
                .onAppear() {
                    isClassOwner(classCode: code, uid: userID) { result in
                            self.isOwner = result
                            }
                    
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
                    
                    getManagerList(classCode: code) { managers in
                        managerList = managers
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
                
                }
            
            .padding(.top, 20)

            Spacer()
            Divider()
            .padding(.top, 20)

            VStack{
                Text("Managers")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .bold()
            }
                    
            List {
                if editing {
                    ForEach(managerList, id: \.self) { person in
                        HStack {
                            Text("\(person)")
                                .bold()
                            Spacer()
                            
                            if(person == userID){
                                
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                            // if you are not the owner, or if u have a diff username to owner,
                            // you can demote students
                            // if you ARE the owner, you can demote and remove, but not remove or demote urself
                            if !isOwner || (isOwner && person != userID) {
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
                }else{
                    ForEach(managerList, id: \.self) { person in
                        
                        HStack {
                            Text("\(person)")
                                .bold()
                            Spacer()
                            
                            if let pfp = peopleToPfp[person]{
                                Image(uiImage: pfp).resizable().clipShape(Circle()).frame(width: 30, height: 30).padding(.trailing).shadow(radius: 2.0,y:2.0)
                            }else{
                                Image(systemName: "person").resizable().clipShape(Circle()).frame(width: 30, height: 30).padding(.trailing).shadow(radius: 2.0,y:2.0)
                            
                            
                        }
                    }
                }
            }
        }
                    


                
                    // students displayed

                    Text("Students")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .bold()
                        .frame(width: 250, alignment: .center)
                        .padding(.top, 18)
                    
                    VStack{
                        HStack{
                            Spacer()
                            Button{
                                editing.toggle()
                            }label: {
                                Image(systemName: editing ? "checkmark.rectangle.stack" : "square.and.pencil").resizable().frame(width: 20,height: 20).padding(.trailing, 13).padding(.bottom, 2).animation(.smooth(duration: 0.65), value: editing)
                            }
                        }
                        List {
                            if editing{
                                ForEach(peopleList, id: \.self) { person in
                                    
                                    HStack {
                                        Text("\(person)")
                                            .bold()
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
                                        Text("\(person)")
                                            .bold()
                                        Spacer()
                                        
                                        if let pfp = peopleToPfp[person]{
                                            Image(uiImage: pfp).resizable().clipShape(Circle()).frame(width: 30, height: 30).padding(.trailing).shadow(radius: 2.0,y:2.0)
                                        }else{
                                            Image(systemName: "person").resizable().clipShape(Circle()).frame(width: 30, height: 30).padding(.trailing).shadow(radius: 2.0,y:2.0)
                                            }

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

