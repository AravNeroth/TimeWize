//
//  TaskView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 2/13/24.
//

import SwiftUI

struct TaskView: View {
    
    var title: String = "Test Title"
    var date: String = "01/01/1999"
    var totalPpl: Int = 0
    var currPpl: Int = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0, style: .circular)
                .frame(width: 375, height: 120)
                .foregroundColor(.green5)
            VStack {
                HStack {
                    Text(title)
                        .font(.largeTitle)
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
                    Text("\(currPpl)/\(totalPpl)")
                    Image(systemName: "person.2")
                }
                .padding(.leading, 275.0)
                .padding(.top, 5.0)
                
                    
            }
        }
    }
}

#Preview {
    TaskView()
}
