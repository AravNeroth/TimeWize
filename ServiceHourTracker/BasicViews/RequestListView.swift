//
//  RequestListView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/24/24.
//

import SwiftUI

struct RequestListView: View {
    
    @State var colorsForRequest: [Request:[Color]] = [:]
    @State var classForRequest: [Request:Classroom] = [:]
    @State var fromManSide = false
    @State var showMessage = false
    @State var pendingRequests: [Request] = []
    @State var acceptedRequests: [Request] = []
    @State var done = false
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var settingsManager: SettingsManager
    @AppStorage("uid") var userID = ""
    
    var body: some View {
        if done {
            ScrollView {
                if !fromManSide {
                    if pendingRequests.isEmpty {
                        Text("No Pending Requests").bold()
                    }
                    else{
                        Text("PENDING REQUESTS").bold()
                        
                        ForEach(pendingRequests) { request in
                            NewRequestView(showMessageSheet: $showMessage, className: classForRequest[request]?.title ?? "No Title", classCode: request.classCode, colors: colorsForRequest[request] ?? [.green4, .green6], title: request.title, description: request.description, verifier: request.verifier, numHours: request.numHours, hourType: request.hourType, email: request.creator, request: request, fromManSide: fromManSide, done: $done)
                        }
                        
                    }
                    
                    Divider() // do yuo use spacer or divider or both for this?
                        .padding(10)
                    
                    // check if there is any accepted
                    if acceptedRequests.isEmpty {
                        Text("No Accepted Requests").bold()
                        
                    }
                    else{
                        Text("ACCEPTED REQUESTS").bold()
                        // if there is accepted req, display
                        ForEach(acceptedRequests) { request in
                            NewRequestView(showMessageSheet: $showMessage, className: classForRequest[request]?.title ?? "No Title", classCode: request.classCode, colors: colorsForRequest[request] ?? [.green4, .green6], title: request.title, description: request.description, verifier: request.verifier, numHours: request.numHours, hourType: request.hourType, email: request.creator, request: request, fromManSide: fromManSide, done: $done)
                        }
                        
                    }
                } else {
                    if pendingRequests.isEmpty {
                        Text("No Pending Requests").bold()
                    }
                    else{
                        Text("PENDING REQUESTS").bold()
                        
                        ForEach(pendingRequests) { request in
                            NewRequestView(showMessageSheet: $showMessage, className: classForRequest[request]?.title ?? "No Title", classCode: request.classCode, colors: colorsForRequest[request] ?? [.green4, .green6], title: request.title, description: request.description, verifier: request.verifier, numHours: request.numHours, hourType: request.hourType, email: request.creator, request: request, fromManSide: fromManSide, done: $done)
                        }
                        
                    }
                }
                        
            }
            .sheet(isPresented: $showMessage) {
                MessageLogView(lastChats: $messageManager.lastMessages, recipientEmail: settingsManager.dm)
                    .padding(.top, 10)
                    .onDisappear {
                        showMessage = false
                    }
            }
        } // end of "done" / end of view
        
         else {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
                    pendingRequests = []
                    acceptedRequests = []
                    colorsForRequest = [:]
                    classForRequest = [:]
                    let group = DispatchGroup()
                    group.enter()
                        
                        if fromManSide { // if user is manager
                            group.enter()
                            
                            getClasses(uid: userID) { classes in
                                defer { group.leave() }
                                
                                if let classes = classes {
                                    for classCode in classes {
                                        group.enter()
                                        
                                        getClassRequests(classCode: classCode) { requests in // below gets all requests in class
                                            defer { group.leave() }
                                            
                                            for request in requests {
                                                group.enter()
                                                
                                                getColorScheme(classCode: classCode) { colors in
                                                    colorsForRequest[request] = colors
                                                    group.leave()
                                                }
                                                group.enter()
                                                
                                                getClassInfo(classCloudCode: classCode) { classroom in
                                                    if let classroom = classroom {
                                                        classForRequest[request] = classroom
                                                    }
                                                    group.leave()
                                                }
                                                pendingRequests.append(request)
                                            }
                                        }
                                    }
                                }
                            }
                        } // end of manager (note* - we need a func that gets logbook of all past accepted requests!
                        
                        else { // if user is student
                            group.enter()
                            
                            getPendingRequests(email: userID) { requests in // gets pending
                                defer { group.leave() }
                                
                                for request in requests {
                                    group.enter()
                                    
                                    getColorScheme(classCode: request.classCode) { colors in
                                        colorsForRequest[request] = colors
                                        group.leave()
                                    }
                                    group.enter()
                                    
                                    getClassInfo(classCloudCode: request.classCode) { classroom in
                                        if let classroom = classroom {
                                            classForRequest[request] = classroom
                                        }
                                        group.leave()
                                    }
                                    pendingRequests.append(request) // finds all pending req & appends to pendingRequest to be displayed
                                }
                                group.enter()
                                getAcceptedRequests(email: userID) { requests in // gets accepted
                                    defer { group.leave() }
                                    for request in requests {
                                        group.enter()
                                        
                                        getColorScheme(classCode: request.classCode) { colors in
                                            colorsForRequest[request] = colors
                                            group.leave()
                                        }
                                        group.enter()
                                        
                                        getClassInfo(classCloudCode: request.classCode) { classroom in
                                            if let classroom = classroom {
                                                classForRequest[request] = classroom
                                            }
                                            group.leave()
                                        }
                                        acceptedRequests.append(request) // finds all accepted req & appends to pendingRequest to be displayed
                                    }
                                }
                            }
                        } // end of from student
                    
                    group.notify(queue: .main) {
                        pendingRequests.sort { $0.timeCreated < $1.timeCreated }
                        acceptedRequests.sort { $0.timeCreated < $1.timeCreated }
                        done = true
                    }
                    group.leave()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        pendingRequests.sort { $0.timeCreated < $1.timeCreated }
//                        acceptedRequests.sort { $0.timeCreated < $1.timeCreated }
//                        done = true
//                    }
                }
        }
    }
}

#Preview {
    RequestListView()
}
