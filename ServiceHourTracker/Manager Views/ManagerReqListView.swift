//
//  ManagerRequestListView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/17/24.
//

import SwiftUI

struct ManagerReqListView: View {
    
    @State var classesList: [String] = []
    @State private var classNamesAndCodes: [String:String] = [:]
    @State var classNamesList: [String] = [] // names
    @State var classCodesList: [String] = [] // codes
    @State var allRequests: [[String:String]] = []
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        ScrollView {
            if allRequests.isEmpty {
                Text("You have no requests")
            } else {
                ForEach(allRequests, id: \.self) { request in
                    RequestView(className: classNamesAndCodes[request["classCode"]!]!, classCode: request["classCode"]!, description: request["description"]!, numHours: Int(request["hours"]!) ?? 0, hourType: request["type"]!, email: request["email"]!, request: request, reqList: $allRequests)
                }
            }
        }
        
        
        .onAppear() {
            getClasses(uid: userID) { currClasses in
                if let currClasses = currClasses {
                    for currClass in currClasses {
                        getClassInfo(classCloudCode: currClass) { classInfo in
                            getClassRequests(classCode: currClass) { requestList in
                                for request in requestList {
                                    //allRequests.append(request)
                                    classNamesAndCodes[currClass] = classInfo!.title
                                    classCodesList.append(currClass)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ManagerReqListView()
}
