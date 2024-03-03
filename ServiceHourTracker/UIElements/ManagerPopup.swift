//
//  ManagerPopup.swift
//  ServiceHourTracker
//
//  Created by kalsky_953982 on 3/2/24.
//

import SwiftUI

struct ManagerPopup: View {
    @Binding var showManOptions: Bool
    @Binding var showPpl:Bool
    @Binding var homeImageSelection: Bool
    @Binding var showTaskPopup: Bool
    @Binding var showPalette: Bool
    var body: some View {
        VStack{
            //                Divider().padding()
            Spacer()
            Button{
                withAnimation(.bouncy){
                    showManOptions = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                        showPpl = true
                    }
                }
            }label: {
                HStack{
                    Image(systemName: "person.3")
                    Text("Class People")
                }
            }.padding()
            Divider().padding()
            Button{
                withAnimation(.easeInOut(duration: 1.5)){
                    showManOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                        homeImageSelection = true
                    }
                    
                }
                
            }label: {
                HStack{
                    Image(systemName: "photo.fill")
                    Text("Edit Class Photo")
                }
            }.padding()
            Divider().padding()
            Button{
                showManOptions = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                    showPalette = true
                }
                
                
            }label: {
                HStack{
                    Image(systemName: "paintpalette.fill")
                    Text("Class Colors")
                }
            }.padding()
            Divider().padding()
            Button{
                
                showManOptions = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                    showTaskPopup = true
                }
                
                
            }label: {
                HStack{
                    Image(systemName: "plus")
                    Text("Add Task")
                }
            }.padding()
        }
    }
}


