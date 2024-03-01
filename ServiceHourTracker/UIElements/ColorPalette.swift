
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
    
    @State private var color1 = Color.white
    @State private var color2 = Color.white
    @State private var currPick = 0
    @EnvironmentObject private var classData:ClassData
    @AppStorage("uid") private var userID = ""
    

    var body: some View {
        ScrollView() {
            
            HStack{
                Image(systemName: "swatchpalette.fill").tint(.black).padding()
                Text("Class Colors").font(.largeTitle).bold()
            }
            
            Spacer(minLength: 20)
            
            VStack{
                
                VStack{
                    HStack(){
                        Image(systemName: "star").frame(width: 20, height: 10).fontWeight(.semibold).padding(.trailing, 5)
                        Text("Popular").font(.title3).fontWeight(.semibold).frame(height: 10)
                        Spacer()
                    }
                    HStack(spacing: 5){
                        Button{
                            currPick = 0
                        }label: {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green2,.green4]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).stroke(.blueLogin, lineWidth: (currPick==0) ? 4:0)
                        }
                        
                        Button{
                            currPick = 1
                        }label: {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue2,.blue4]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).stroke(.blueLogin, lineWidth: (currPick==1) ? 4:0)
                        }
                        
                        Button{
                            currPick = 2
                        }label: {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple2,.purple4]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ).stroke(.blueLogin, lineWidth: (currPick==2) ? 4:0)
                        }
                        
                        
                    }.padding()
                }
                
                VStack{
                    HStack(){
                        Image(systemName: "swatchpalette")
                        Text("other").font(.subheadline).fontWeight(.regular)
                        Spacer()
                    }
                    
                    /*
                    ScrollView(.horizontal){
                        ScrollViewReader { scrollView in
                            HStack{
                                
                                Button{
                                    withAnimation {
                                       currPick = 3
                                       scrollView.scrollTo(0, anchor: .center)
                                   }
                                }label: {
                                    Circle().fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.red,.gray]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    ).stroke(.blueLogin, lineWidth: (currPick==3) ? 4:0).frame(width:75, height: 75)
                                }
                                
                                Button{
                                    currPick = 4
                                }label: {
                                    Circle().fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.black,.gray]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    ).stroke(.blueLogin, lineWidth: (currPick==4) ? 4:0).frame(width:75, height: 75)
                                }
                                
                                Button{
                                    currPick = 5
                                }label: {
                                    Circle().fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.green,.white]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    ).stroke(.blueLogin, lineWidth: (currPick==5) ? 4:0).frame(width:75, height: 75)
                                }
                                
                                Button{
                                    withAnimation {
                                       currPick = 6
                                       scrollView.scrollTo(6, anchor: .center)
                                   }
                                }label: {
                                    Circle().fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue,.yellow,.white]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    ).stroke(.blueLogin, lineWidth: (currPick==6) ? 4:0)
                                        .frame(width:75, height: 75)
                                }
                                
                                
                            }.padding().onAppear {
                                // Scroll to the middle circle initially
                                scrollView.scrollTo(5, anchor: .center)
                            }
                        }
                    }
                    */
                    ScrollView(.horizontal) {
                                ScrollViewReader { scrollView in
                                    HStack {
                                        ForEach(3..<10) { index in
                                            Button {
                                                withAnimation {
                                                    currPick = index
                                                    scrollView.scrollTo(index, anchor: .center)
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
                                                .frame(width: 75, height: 75)
                                            }
                                        }
                                    }.frame(height: 83)
                               
                                    .onAppear {
                                        // Scroll to the middle circle initially
                                        scrollView.scrollTo(5, anchor: .center)
                                    }
                                }
                            }
                    
                    
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
                
                
            }
            
            
        }
        .padding(10)
            .background(.white).cornerRadius(10) // was green3
       .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1)) // was green6
       .padding(.horizontal)
    }
           
       
           
    private func colorsForIndex(_ index: Int) -> [Color] {
            switch index {
            case 3: return [.red, .gray]
            case 4: return [.black, .gray]
            case 5: return [.green, .white]
            case 6: return [.red, .orange]
            case 7: return [.blue, .yellow, .white]
            case 8: return [.yellow, .blueLogin]
            case 9: return [.green1, .green5]
                
            default: return []
            }
        }
            
    }
