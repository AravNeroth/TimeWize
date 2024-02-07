//
//  TermsAndServices.swift

//
//  Created by kalsky_953982 on 10/8/23.
//

import SwiftUI

struct TermsAndServices: View {
    var body: some View {
        VStack(alignment: .center){
            Text("Terms and Services").bold().font(.largeTitle).padding()
            Spacer()
            Text("Here are the terms and services for the TimeWize App: ").font(.title3)
            ScrollView{
                Text("This is an app created by TWolf-Tech 2023-2024 by Jonathan Kalsky, Parker Huang, Verlyn Fischer, and Arav Neroth. \n\n By creating an account and using this app, you are agreeing to the usage of your account to manage data you set up in your profile. This app uses a database to handle information, and you are agreeing that you are aware.\n\n to contact us email Jonathan.Kalsky@gmail.com : Jonathan Kalsky, 2findmyemail@gmail.com : Arav Neroth, \n:Parker Huang, \n:Verlyn Fischer.").padding()
            }
            
            Image(systemName: "case.fill").resizable().frame(width: 100,height: 100)
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
        
    }
}

#Preview {
    TermsAndServices()
}
