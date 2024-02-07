//
//  ManagerClassJoining.swift
//  ServiceHourTracker
//
//  Created by neroth_927927 on 2/6/24.
//

import Foundation
import SwiftUI

struct JoinCodesView: View {
    
    // idk how to link these to the generator
    @State private var studentCode = ""
    @State private var teacherCode = ""
    
    var body: some View {
        VStack {
            
            Text("Join codes for (class name)")
                            .font(.title)
                            .padding(.top, 50)
            
            Text("Join Code for Students")
                .font(.headline)
                .padding(.top, 110)
            
            TextField("*Display Student Code*", text: $studentCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            
            Text("Display Code for Teachers")
                .font(.headline)
            
            TextField("*Insert Teacher Code*", text: $teacherCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

struct JoinCodesView_Previews: PreviewProvider {
    static var previews: some View {
        JoinCodesView()
    }
}
