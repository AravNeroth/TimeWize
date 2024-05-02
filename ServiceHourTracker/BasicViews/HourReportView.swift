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
                HStack {
                    Text(person)
                        .font(.title3)
                        .bold()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }
                
                ForEach (arr.sorted(by: { $0.timeCreated < $1.timeCreated }), id: \.timeCreated) { req in
                    VStack {
                        HStack {
                            Text("\(req.title)")
                                .font(.headline)
                                .bold()
                                .padding(.horizontal, 30)
                            
                            Spacer()
                            
                            Text("\(reportDate(req.timeCreated))")
                                .font(.headline)
                                .bold()
                                .padding(.horizontal, 30)
                        }
                        .padding(.bottom, 2.5)
                        
                        HStack {
                            Text("Description: \(req.description)")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .padding(.horizontal, 30)
                            
                            Spacer()
                            
                            Text("Reference: \(req.verifier)")
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal, 30)
                        }
                        .padding(.bottom, 2.5)
                        
                        HStack {
                            Text("Hours: \(req.numHours)")
                                .font(.subheadline)
                                .lineLimit(1)
                                .padding(.horizontal, 30)
                            
                            Spacer()
                            
                            Text("Hour Type: \(req.hourType)")
                                .font(.subheadline)
                                .lineLimit(1)
                                .padding(.horizontal, 30)
                        }
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    HourReportView(reqsPerPerson: ["First Person":[Request(title: "Test Title", description: "Competed in 4 Comps for UIL Districts", timeCreated: Date(), hourType: "Service", numHours: 2, verifier: "Mr. Marsh"), Request()],"Second Person":[Request(), Request()]])
}
