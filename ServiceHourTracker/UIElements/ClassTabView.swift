//
//  ClassTabView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/8/23.
//

import SwiftUI

struct ClassTabView: View {
    
    var name: String
    var mainManager: String
    @EnvironmentObject var settingsManager: SettingsManager
    @State var navToClass = false
    var banner: UIImage? = UIImage(resource: .image3)
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 375, height: 120)
                .foregroundColor(.green5)
                

            VStack{
                Spacer()
                HStack{
                    Spacer()
                    ZStack(alignment: .bottomTrailing){
                        
                        if let banner = banner{
                            Image(uiImage: banner).frame(width: 375, height: 50).cornerRadius(20, corners: [.bottomRight, .bottomLeft]).opacity(0.8)
                        }
                        HStack(alignment: .bottom){
             
//                            Image(systemName: "person.circle").resizable().frame(width: 30, height: 30).padding()
                            VStack(alignment: .trailing){
                                Spacer()
                                Image(.image2).resizable().clipShape(Circle()).frame(width: 30, height: 30)
                            }.padding(4)
                        }.padding(4)
                        
                    }.padding(.trailing, 9)
                }.padding(0)
            }
            VStack {
                Spacer()
                HStack{
                    Text(name)
                        .font(.title)
                        .fontWeight(.black)
                        .frame(width: 315, alignment: .leading)
//                        .onTapGesture {
//                            settingsManager.tab = 4
//        //                    tabNum = 4
//                            print("tap")
//                            currentView = .classroomView
//                            settingsManager.title = name
//                            
//                        }
                    Button{
                        print("classTab settings")
                    }label: {
                        Image(systemName: "line.3.horizontal").fontWeight(.black)
                    }.frame(alignment: .trailing)
                }.shadow(radius: 10)
                    
                .foregroundStyle((settingsManager.isDarkModeEnabled) ? .white : .green1)
                    
                
                
                Spacer()
           
                
                Spacer()
            }
            .frame(height: 90)
            
        }
//        .overlay(
//            RoundedRectangle(cornerRadius: 30)
//             
//             .stroke((settingsManager.isDarkModeEnabled) ? .white : .black, lineWidth: 0.5)
//        )
            .padding(.vertical, 5.0)
            
        

    }
   
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


