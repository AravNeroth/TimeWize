//
//  ClassTabView.swift
//  ServiceHourTracker


import SwiftUI

struct ManagerTabView: View {
    
    var name: String
    var classCode: String
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    
    @State var navToClass = false
    var banner: UIImage? = UIImage(resource: .image3)
    var pfp: UIImage? = UIImage(resource: .image2)
    @AppStorage("uid") private var userID = ""
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 375, height: 120)
                .foregroundColor(.green5)
                .overlay(
                    
                    
                    VStack(alignment: .center){
                        Spacer()
                        HStack{
                            Spacer()
                            ZStack(alignment: .bottomTrailing){
                                
                                if let banner = banner{
                                    Image(uiImage: banner)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 375, height: 50)
                                        .cornerRadius(30, corners: [.bottomRight, .bottomLeft])
                                        .opacity(0.8)
                                }
                                HStack(alignment: .bottom){
                                    
                                    VStack(alignment: .trailing){
                                        Spacer()
                                        if let pfp = pfp{
                                            Image(uiImage: pfp)
                                                .resizable()
                                                .clipShape(Circle())
                                                .frame(width: 30, height: 30)
                                        }
                                    }.padding(4)
                                }.padding(4)
                                
                            }
                            .padding(.trailing, 8)
                        }.padding(0)
                    }
                )
            VStack {
                Spacer()
                HStack{
                    //                    Button{
                    //                        settingsManager.tab = 2
                    //
                    //
                    //                        settingsManager.title = name
                    //                        classData.code = classCode
                    //
                    //                    }label: {
                    //                        Text(name)
                    //                        .font(.title)
                    //                        .fontWeight(.black)
                    //                        .frame(width: 315, alignment: .leading)
                    //                    }
                    
                    //                    NavigationLink(destination: ManagerClass()) {
                    //                        Text(name)
                    //                        .font(.title)
                    //                        .fontWeight(.black)
                    //                        .frame(width: 315, alignment: .leading)
                    //
                    //                    }.onTapGesture {
                    //                        print("tapped manager class")
                    //                        classData.code = classCode
                    //                        settingsManager.title = name
                    //                    }
                    
                    Button{
                        print("tapped manager class")
                        classData.code = classCode
                        settingsManager.title = name
                        navToClass = true
                    }label: {
                        Text(name)
                            .font(.title)
                            .fontWeight(.black)
                            .frame(width: 315, alignment: .leading)
                    }
                    
                    //                        NavigationLink(destination: ManagerClass()) {
                    //                            Text(name)
                    //                            .font(.title)
                    //                            .fontWeight(.black)
                    //                            .frame(width: 315, alignment: .leading)
                    //
                    //                        }
                    
                    
                    
                    Button{
                        
                    }label: {
                        Image(systemName: "gearshape").fontWeight(.black)
                    }
                    .frame(alignment: .trailing)
                    
                    
                }.shadow(radius: 10)
                
                    .foregroundStyle((settingsManager.isDarkModeEnabled) ? .white : .green1)
                
                
                
                Spacer()
                
                
                Spacer()
            }
            .frame(height: 90)
            NavigationLink(
                destination: ManagerRoomView(),
                            isActive: $navToClass,
                            label: {
                                EmptyView()
                            })
        }
        
        //            .padding(.vertical, 5.0)
        
        
        

    }
    
}
   





