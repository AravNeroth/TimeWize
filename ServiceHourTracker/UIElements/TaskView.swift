//
//  TaskView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/13/24.
//

import SwiftUI

struct TaskView: View {
    
    @State var title: String = "Test Title"
    @State var date: String = "01/01/1999"
    @State var totalPpl: Int = 0
    @State var currPpl: Int = 0
    @State var isSignedUp: Bool = false
    @State var showingAlert: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0, style: .circular)
                .frame(width: 375, height: 120)
                .foregroundColor(.green5)
            VStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .bold()
                        .padding(.horizontal, 30)
                    Spacer()
                    Text(date)
                        .font(.headline)
                        .padding(.horizontal, 25)
                }.padding(.bottom, 10)
                
                Divider()
                    .frame(width: 375)
                
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
                                currPpl += 1
                            } else {
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
                .padding(5.0)
            }
        }
    }
}

#Preview {
    TaskView()
}
