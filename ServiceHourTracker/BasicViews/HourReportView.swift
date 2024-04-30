//
//  HourReportView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 4/22/24.
//

import SwiftUI

struct HourReportView: View {
    
    @State var reqsPerPerson: [String:[Request]] = [:]
    
    var body: some View {
        VStack {
            Text("Hour Report")
                .font(.title)
                .bold()
                .padding(20)
            
            ForEach (reqsPerPerson.sorted(by: { $0.key < $1.key }), id: \.key) { person, arr in
                Text(person)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 5)
                
                ForEach (arr) { req in
                    
                }
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    HourReportView(reqsPerPerson: ["First Person":[Request(), Request()],"Second Person":[Request(), Request()]])
}
