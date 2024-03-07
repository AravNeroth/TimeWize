//
//  MiniProfileView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 3/1/24.
//

import SwiftUI

struct MiniProfileView: View {
    
    @State var userEmail: String = ""
    @State var userPfp: UIImage? = UIImage(resource: .image2)
    @State var username = ""
    @State var personCols: [Color] = [.green4, .green6]
    @State var currentUser: String = ""
    @State var classOwner: String = ""

    var body: some View {
        RoundedRectangle(cornerRadius: 50.0)
            .fill(LinearGradient(gradient: Gradient(colors: personCols), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(height: 40)
            .padding(.horizontal, 20.0)
            .overlay(
                HStack {
                    ZStack {
                        if let userPfp = userPfp {
                            Image(uiImage: userPfp)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                                .shadow(radius: 2.0, y: 2.0)
                        } else {
                            Image(systemName: "person")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                                .shadow(radius: 2.0, y: 2.0)
                                .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                        }
                    }
                    .padding(.leading, 30.0)
                    .padding(.trailing, 10.0)
                    
                    Text("\(username)")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                    
                    if(currentUser == classOwner) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 15.0, weight: .bold))
                            .imageScale(.large)
                            .rotationEffect(.degrees(90.0))
                            .foregroundStyle(personCols.first!.isBright() ? .black : .white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 40.0)
                }
            )
    }
}
