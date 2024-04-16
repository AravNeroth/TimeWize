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
    @State var fromManSide = true
    @State var checkAccepted = false
    @State var requestList: [Request] = []
    @State var done = false
    @AppStorage("uid") var userID = ""
    
    var body: some View {
        if done {
            ScrollView {
                if !requestList.isEmpty {
                    ForEach(requestList) { request in
                        NewRequestView(className: classForRequest[request]!.title, classCode: request.classCode, colors: colorsForRequest[request]!, description: request.description, numHours: request.numHours, hourType: request.hourType, email: request.creator, request: request, fromManSide: fromManSide, done: $done)
                    }
                } else {
                    if fromManSide {
                        Text("No Requests")
                    } else {
                        Text("No Requests Pending")
                    }
                }
            }
        } else {
            LoadingScreen()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ignoresSafeAreaEdges: .all)
                .onAppear() {
                    requestList = []
                    colorsForRequest = [:]
                    classForRequest = [:]
                    
                    print("fromManSide: \(fromManSide)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        if fromManSide {
                            getClasses(uid: userID) { classes in
                                if let classes = classes {
                                    for classCode in classes {
                                        getClassRequests(classCode: classCode) { requests in
                                            for request in requests {
                                                getColorScheme(classCode: classCode) { colors in
                                                    colorsForRequest[request] = colors
                                                }
                                                getClassInfo(classCloudCode: classCode) { classroom in
                                                    if let classroom = classroom {
                                                        classForRequest[request] = classroom
                                                    }
                                                }
                                                requestList.append(request)
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            if !checkAccepted {
                                getPendingRequests(email: userID) { requests in
                                    print(requests)
                                    for request in requests {
                                        getColorScheme(classCode: request.classCode) { colors in
                                            colorsForRequest[request] = colors
                                        }
                                        getClassInfo(classCloudCode: request.classCode) { classroom in
                                            if let classroom = classroom {
                                                classForRequest[request] = classroom
                                            }
                                        }
                                        requestList.append(request)
                                    }
                                }
                            } 
                            else {
                                getAcceptedRequests(email: userID) { requests in
                                    print(requests)
                                    for request in requests {
                                        getColorScheme(classCode: request.classCode) { colors in
                                            colorsForRequest[request] = colors
                                        }
                                        getClassInfo(classCloudCode: request.classCode) { classroom in
                                            if let classroom = classroom {
                                                classForRequest[request] = classroom
                                            }
                                        }
                                        requestList.append(request)
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        requestList.sort { $0.timeCreated < $1.timeCreated }
                        done = true
                    }
                }
        }
    }
}

#Preview {
    RequestListView()
}
