//
//  TaskView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/13/24.
//

import SwiftUI

struct TaskView: View {
    
    @State var classCode: String = ""
    @State var title: String = "Test Title"
    @State var date: String = "01/01/1999"
    @State var totalPpl: Int = 0
    @State var currPpl: Int = 0
    @State var isSignedUp: Bool = false
    @State var showingAlert: Bool = false
    @State var participants: [String] = []
    @State var numHours: Int = 0
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0, style: .circular)
                .frame(width: 375, height: 150)
                .foregroundColor(.green5)
                .overlay(
            VStack {
                Text(title)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Text("Hours: \(numHours)")
                        .font(.title3)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .padding(.horizontal)
                    
                    Text(date)
                        .font(.title3)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .padding(.horizontal)
                }
                        
                Divider()
                    .frame(width: 350)
                    .padding(5)
                    .padding(.bottom, 5)
                        
                HStack {
                    Spacer()
                            
                    if totalPpl == currPpl {
                        Button(action: {
                            showingAlert = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7.5)
                                    .foregroundStyle(.gray)
                                    .frame(width: 100, height: 25)
                                Text("Sign Up")
                                    .foregroundStyle(.black)
                            }
                        }.alert("Cannot Sign Up, Task Is Full", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) {}
                        }
                    } else {
                        Button(action: {
                            isSignedUp.toggle()
                                    
                            if isSignedUp {
                                participants.append(userID)
                                updateTaskParticipants(classCode: classCode, title: title, listOfPeople: participants)
                                currPpl += 1
                            } else {
                                participants.remove(at: participants.firstIndex(of: userID)!)
                                updateTaskParticipants(classCode: classCode, title: title, listOfPeople: participants)
                                currPpl -= 1
                            }
                                    
                        }) {
                            if isSignedUp {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7.5)
                                        .foregroundStyle(.red)
                                        .frame(width: 100, height: 25)
                                    Text("Quit")
                                        .foregroundStyle(.black)
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7.5)
                                        .foregroundStyle(.green)
                                        .frame(width: 100, height: 25)
                                    Text("Sign Up")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                            
                    Spacer()
                            
                    HStack {
                        Text("\(currPpl)/\(totalPpl)")
                            .bold()
                        Image(systemName: "person.2")
                            .bold()
                    }
                            
                    Spacer()
                }
            })
//            .onAppear() {
//                getTaskParticipants(classCode: classCode, title: title) { peopleList in
//                    participants = peopleList
//                    currPpl = participants.count
//                    if participants.firstIndex(of: userID) == nil {
//                        isSignedUp = false
//                    } else {
//                        isSignedUp = true
//                    }
//                }
//             }
        }
    }
}

#Preview {
    TaskView()
}
