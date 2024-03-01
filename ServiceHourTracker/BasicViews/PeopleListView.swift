//
//  PeopleListView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/22/24.
//

import SwiftUI

struct PeopleListView: View {
    
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
            
            ForEach(peopleList, id: \.self) { person in
                HStack {
                    Text("\(person)")
                        .bold()
                }
            }
        }
        .onAppear() {
            getPeopleList(classCode: code) { people in
                peopleList = people
            }
        }
    }
}


