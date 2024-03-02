//
//  ManagerPeopleListView.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 2/29/24.
//

import Foundation
import SwiftUI

struct ManagerPeopleListView: View {
    
    @AppStorage("uid") var userID = ""
    @State var code: String
    @State var classTitle: String = ""
    @State var peopleList: [String] = []
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Text("List of People in \(classTitle)")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .bold()
                .frame(width: 350, alignment: .center)
            
            Divider()
                .padding(30)
                .frame(width: 350)
            
            List {
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
                }
                .onDelete { indexSet in
                    
                    indexSet.forEach { index in
                        let person = peopleList[index]
                        removePersonFromClass(person: person, classCode: code)
                    }
                    
                    withAnimation {
                        peopleList.remove(atOffsets: indexSet)
                    }
                }
            }
        }
        .padding(.top, 20)
        .onAppear() {
            getPeopleList(classCode: code) { people in
                peopleList = people
                
            }
        }
    }
}
