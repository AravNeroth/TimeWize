//
//  ClassTabView.swift
//  ServiceHourTracker


import SwiftUI

struct ClassTabView: View {
    
    var name: String
    var classCode: String
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var classData: ClassData
    var banner: UIImage? = UIImage(resource: .image3)
    var pfp: UIImage? = UIImage(resource: .image2)
    @AppStorage("uid") private var userID = ""
    @Binding var allClasses: [Classroom]
    @State var classroom: Classroom
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 375, height: 120)
                .foregroundColor(.green5)
                .overlay(
            VStack(alignment: .center) {
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
                        HStack(alignment: .bottom) {

                            VStack(alignment: .trailing) {
                                Spacer()
                                if let pfp = pfp {
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
            })
            VStack {
                Spacer()
                HStack {
                    Button {
                        settingsManager.tab = 4
                        print("tap")
                        currentView = .ClassroomView
                        settingsManager.title = name
                        classData.code = classCode
                        
                    } label: {
                        Text(name)
                        .font(.title)
                        .fontWeight(.black)
                        .frame(width: 315, alignment: .leading)
                    }
                    
                    Menu {
                        Button {
                            getCodes(uid: userID) { codesList in
                                if let codesList = codesList {
                                    unenrollClass(uid: userID, codes: codesList, code: classCode)
                                    allClasses.remove(at: allClasses.firstIndex(of: classroom)!)
                                    removePersonFromClass(person: userID, classCode: classCode)
                                }
                            }
                        } label: {
                            Text("Unenroll Class")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal").fontWeight(.black)
                    }.frame(alignment: .trailing)

                    
                }.shadow(radius: 10)
                    
                .foregroundStyle((settingsManager.isDarkModeEnabled) ? .white : .green1)
                    
                
                
                Spacer()
           
                
                Spacer()
            }
            .frame(height: 90)
            
        }
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
