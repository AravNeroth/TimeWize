
//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Jonathan Kalsky on 2/20/24.
//
import Foundation
import SwiftUI



struct UserColorPalette: View {
    
    @Binding var showPop: Bool
    @Binding var refresh: Bool
   
    @State private var featuredColors: [[Color]] = [[.green4, .green6], [.blue4, .blue6],[.purple4, .purple6]]
    @State private var currPick = -1
    @EnvironmentObject private var classData: ClassData
    @AppStorage("uid") private var userID = ""
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("App Theme")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20.0)
            
            Text("Current Colors")
                .font(.title3)
                .fontWeight(.semibold)
            
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: settingsManager.userColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 100)
                .shadow(radius: 2.0, y: 2.0)
            
            Text("Featured")
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack {
                Button {
                    currPick = 0
                    
                    settingsManager.userColors = featuredColors[0]
                } label: {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: featuredColors[0]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .stroke(.blueLogin, lineWidth: (currPick == 0) ? 4 : 0)
                        .shadow(radius: 2.0, y: 2.0)
                }
                
                Button {
                    currPick = 1
                    
                    settingsManager.userColors = featuredColors[1]
                } label: {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: featuredColors[1]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        .shadow(radius: 2.0, y: 2.0)
                }
                
                Button {
                    currPick = 2
                    
                    settingsManager.userColors = featuredColors[2]
                } label: {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: featuredColors[2]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .stroke(.blueLogin, lineWidth: (currPick == 2) ? 4 : 0)
                        .shadow(radius: 2.0, y: 2.0)
                }
            }
            .padding(.horizontal, 30.0)
            
            Text("Others")
                .font(.title3)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollView in
                    HStack {
                        Text("")
                        
                        ForEach(3..<13) { index in
                            Button {
                                currPick = index
                                scrollView.scrollTo(index, anchor: .center)
                                
                                settingsManager.userColors = colorsForIndex(index)
                            } label: {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: colorsForIndex(index)), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .stroke(.blue, lineWidth: (currPick == index) ? 4 : 0)
                                    .shadow(radius: 2.0, y: 2.0)
                            }
                            .padding(.vertical, 5.0)
                        }
                    }
                }
            }
            .frame(height: 100)
            
            Spacer()
            
            Button {
                
                setUserColors(email: userID, colors: settingsManager.userColors)
                showPop = false
                refresh = true
            } label: {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.blueLogin)
                    .frame(height: 60)
                    .padding(.horizontal, 30.0)
                    .overlay(
                        Text("Select")
                            .foregroundStyle(.white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
    }
    
    private func colorsForIndex(_ index: Int) -> [Color] {
        switch index {
        case 0: return [.green4, .green6]
        case 1: return [.blue4, .blue6]
        case 2: return [.purple4, .purple6]
        case 3: return [hexToColor(hex: "3C3B3F"), hexToColor(hex: "605C3C")] // Selenium
        case 4: return [hexToColor(hex: "C31432"), hexToColor(hex: "240B36")] // Witching Hour
        case 5: return [hexToColor(hex: "2E3192"), hexToColor(hex: "1FACAC")] // Ocean Blue
        case 6: return [hexToColor(hex: "02AABD"), hexToColor(hex: "00CDAC")] // Green Beach
        case 7: return [hexToColor(hex: "3494E6"), hexToColor(hex: "EC6EAD")] // Vice City
        case 8: return [hexToColor(hex: "000428"), hexToColor(hex: "004E92")] // Frost
        case 9: return [hexToColor(hex: "11998E"), hexToColor(hex: "38EF7D")] // Quepal
        case 10: return [hexToColor(hex: "f7ff00"), hexToColor(hex: "db36a4")] // Alihossein
        case 11: return [hexToColor(hex: "7b4397"), hexToColor(hex: "dc2430")] // Virgin America
        case 12:return [hexToColor(hex: "832388"), hexToColor(hex: "E3436B")]
        default: return []
        }
    }
}
