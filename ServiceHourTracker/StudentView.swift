//
//  TestView.swift
//  ServiceHourTracker
//
//  Created by huang_931310 on 12/10/23.
//  Edited by Jonathan Kalsky 1/19/24
//

import SwiftUI
enum view{
    case HourBoardView
    case SettingsView
    case ClassesView
}

var currentView: view = .ClassesView


struct StudentView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State var tabSelection = 2
    @State var title = "Classes"
    
    var body: some View {
        NavigationView {
         

            
            switch currentView {
            case .ClassesView:
                ClassesView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(title).toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            
                        }label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        
                        bottomPicks(selection: $tabSelection)
                        
                    }
                }
            case .SettingsView:
                SettingsView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(title).toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            
                        }label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        
                        bottomPicks(selection: $tabSelection)
                        
                    }
                }
            case .HourBoardView:
                HourBoardView().navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true).navigationTitle(title).toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            
                        }label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        
                        bottomPicks(selection: $tabSelection)
                        
                    }
                }
            }
                   
                
            
        }.onChange(of: tabSelection, { old, new in
            switch tabSelection{
            case 0: title = "Hours Log"; currentView = .HourBoardView
            case 2: title = "Classes"; currentView = .ClassesView
            case 3: title = "Settings"; currentView = .SettingsView
            default:
                title = ""
            }
        })
        .onAppear(){
            print("appeared")
        }
        .preferredColorScheme(.dark)
    }
}





//MARK: toolbar
struct bottomPicks: View {
    @Binding var selection: Int
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        HStack{
            Spacer()
            Button{
//                currentView = .HourBoardView
                selection = 0
            }label: {
                VStack{
//                                    Spacer()
                    Image(systemName: "clock.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Hours Log").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{
//                currentView = .ClassesView
                selection = 2
            }label: {
                VStack{
//                                    Spacer()
                    Image(systemName: "house.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Classes").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
            Button{
//                currentView = .SettingsView
                selection = 3
            }label: {
                VStack{

                    Image(systemName: "gearshape.fill").tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                    Text("Settings").font(.caption).tint((settingsManager.isDarkModeEnabled) ? .white : .green5)
                }
            }
            Spacer()
        }.padding(.top)
    }
}

#Preview {
    StudentView()
        
}
