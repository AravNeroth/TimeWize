//
//  ManagerRequestListView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/17/24.
//

import SwiftUI

struct ManagerReqListView: View {
    
    @State var classesList: [String] = []
    @State var classNamesList: [String] = []
    @State var classCodesList: [String] = []
    @State var allRequests: [[String:String]] = []
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        ScrollView {
            ForEach(allRequests, id:\.self) { request in
                RequestView(className: classNamesList.removeFirst(), classCode: classCodesList.removeFirst(), description: request["description"]!, numHours: Int(request["hours"]!) ?? 0, hourType: request["type"]!, email: request["email"]!, request: request)
            }
        }
        .onAppear() {
            getClasses(uid: userID) { currClasses in
                if let currClasses = currClasses {
                    for currClass in currClasses {
                        classesList.append(currClass)
                    }
                }
                for currClass in classesList {
                    getClassInfo(classCloudCode: currClass) { classInfo in
                        getRequests(classCode: currClass) { requestList in
                            for request in requestList {
                                allRequests.append(request)
                                classNamesList.append(classInfo!.title)
                                classCodesList.append(currClass)
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
