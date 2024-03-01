
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
                Text("Class Colors").font(.title).bold()
            }
            
            Spacer()
            
            VStack{
                HStack(spacing: 5){
                    Button{
                        currPick = 0
                    }label: {
                        Circle().fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue,.yellow]),
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
                                gradient: Gradient(colors: [.purple,.white]),
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
                                gradient: Gradient(colors: [.red,.orange]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ).stroke(.blueLogin, lineWidth: (currPick==2) ? 4:0)
                    }
                    
                    
                }.padding()
                HStack(spacing: 5){
                    
                    Button{
                        currPick = 3
                    }label: {
                        Circle().fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red,.gray]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ).stroke(.blueLogin, lineWidth: (currPick==3) ? 4:0)
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
                        ).stroke(.blueLogin, lineWidth: (currPick==4) ? 4:0)
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
                        ).stroke(.blueLogin, lineWidth: (currPick==5) ? 4:0)
                    }
                    
                    Button{
                        currPick = 6
                    }label: {
                        Circle().fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue,.yellow,.white]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ).stroke(.blueLogin, lineWidth: (currPick==6) ? 4:0)
                    }
                    
                    
                }.padding()
                
                
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
           
       
           

            
    }
