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
    @State var requestList: [Request] = []
    @State var done = false
    @AppStorage("uid") var userID = ""
    
    var body: some View {
        if done {
            if fromManSide {
                ScrollView {
                    ForEach(requestList) { request in
                        NewRequestView(className: classForRequest[request]!.title, classCode: request.classCode, colors: colorsForRequest[request]!, description: request.description, numHours: request.numHours, hourType: request.hourType, email: request.creator, request: request, fromManSide: fromManSide, done: $done)
                    }
                }
            } else {
                ScrollView {
                    
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
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
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        done = true
                    }
                }
        }
    }
}

#Preview {
    RequestListView()
}
