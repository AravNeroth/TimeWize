
//
//  ManagerTestClass.swift
//  ServiceHourTracker
//
//  Created by Jonathan Kalsky on 2/20/24.
//
import Foundation
import SwiftUI



struct ColorPalette: View {
    @Binding var showPop: Bool
    
    @State private var colorsSelected: [Color] = [.white]
    @State private var featuredColors: [[Color]] = [[.green2,.green4],[.blue2,.blue4],[.purple2,.purple4]]
    
    @State private var currPick = 0
    @EnvironmentObject private var classData:ClassData
    @AppStorage("uid") private var userID = ""


    var body: some View {
        VStack() {
            
            HStack{
                Image(systemName: "swatchpalette.fill").tint(.black).padding()
                Text("Class Colors").font(.largeTitle).bold()
            }
            
            Spacer(minLength: 20)
            
            VStack{
                
                VStack{
                    HStack(){
                        Image(systemName: "star").frame(width: 20, height: 10).fontWeight(.semibold).padding(.trailing, 5)
                        Text("Featured").font(.title3).fontWeight(.semibold).frame(height: 10)
                        Spacer()
                    }.padding(10)
                    HStack(spacing: 5){
                        Button{
                            currPick = 0
                            colorsSelected = featuredColors[0]
                        }label: {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: featuredColors[0]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).stroke(.blueLogin, lineWidth: (currPick == 0) ? 4:0)
                                .shadow(radius: 2.0, y: 2.0)
                        }
                        
                        Button{
                            currPick = 1
                            colorsSelected = featuredColors[1]
                        }label: {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: featuredColors[1]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).stroke(.blueLogin, lineWidth: (currPick == 1) ? 4:0)
                                .shadow(radius: 2.0, y: 2.0)
                        }
                        
                        Button{
                            currPick = 2
                            colorsSelected = featuredColors[2]
                        }label: {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: featuredColors[2]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).stroke(.blueLogin, lineWidth: (currPick == 2) ? 4:0)
                                .shadow(radius: 2.0, y: 2.0)
                        }
                        
                        
                    }.padding()
                }
                
                VStack{
                    HStack(){
                        Image(systemName: "swatchpalette")
                        Text("others").font(.subheadline).fontWeight(.regular)
                        Spacer()
                    }.padding(10)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { scrollView in
                                    HStack {
                                        Spacer()
                                        ForEach(3..<10) { index in
                                            Button {
                                                withAnimation {
                                                    currPick = index
                                                    scrollView.scrollTo(index, anchor: .center)
                                                    colorsSelected = colorsForIndex(index)
                                                }
                                                
                                            } label: {
                                                Circle().fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: colorsForIndex(index)),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .stroke(.blue, lineWidth: (currPick == index) ? 4 : 0)
                                                .shadow(radius: 2.0, y: 2.0)
                                                .frame(width: 78, height: 78)
                                            }
                                        }
                                        Spacer()
                                    }.frame(height: 90)
                               
                                    .onAppear {
                                        // Scroll to the middle circle initially
                                        scrollView.scrollTo(5, anchor: .center)
                                    }
                                }
                    }.ignoresSafeArea()
                    
                    
                }
                
            }
            
            Spacer()
            VStack{
                Spacer()
            }
            
            HStack(){
                Spacer()
                RoundedRectangle(cornerRadius: 30).fill(.blueLogin).frame(width: 100, height:50).overlay(
                Button("Select"){
                    
                    setColorScheme(classCode: classData.code, colors: colorsSelected)
                    
                    
                    showPop = false
                }.tint(.white)
                    )
                
                Spacer()
//                RoundedRectangle(cornerRadius: 30).fill(.blueLogin).frame(width: 100, height:50).overlay(
//                Button("Cancel"){
//                    showPop = false
//                }.tint(.white)
//                    )
//                
//                Spacer()
                
                
            }.padding(.bottom, 10)
            
            
        }
       
            .background(.white)
            .cornerRadius(10) // was green3
            .background(RoundedRectangle(cornerRadius: 10)
            .stroke(.black, lineWidth: 1)) // was green6
            .frame(width: 350, height: 500)
    }
           
       
           
    private func colorsForIndex(_ index: Int) -> [Color] {
                switch index {
                case 3: return [hexToColor(hex: "2E3192"), hexToColor(hex: "1FACAC")] // Ocean Blue
                case 4: return [hexToColor(hex: "614385"), hexToColor(hex: "516395")] // Kashmir
                case 5: return [hexToColor(hex: "02AABD"), hexToColor(hex: "00CDAC")] // Green Beach
                case 6: return [.red, .orange]
                case 7: return [.blue, .yellow]
                case 8: return [hexToColor(hex: "11998E"), hexToColor(hex: "38EF7D")] // Quepal
                case 9: return [hexToColor(hex: "FF61D2"), hexToColor(hex: "FE9090")] // Exotic
                    
                default: return []
                }
            }
                
        }
