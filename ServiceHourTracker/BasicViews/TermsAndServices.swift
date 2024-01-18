//
//  TermsAndServices.swift
//  QuickWorksMVP
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
                Text("awbdibawodinawiopdnapwodnapowdnapowdnpoawndopanwdpoanwdopnawpodnapowdnopawndpoawndopawndpoawdopanwdopnawpodnaowpdnapowdnpoawdnapowdnpaowdnoapwdnapowdnopawdnoapwndopawndopawndpoanwdopanwdopanwdponawdonawpodnawopdnaopwdnaowdnapowdnapowdnapwodnaowndaopwdnapwdpnawpdonawopdnoapwdnopa").padding()
            }
            
            Image(systemName: "case.fill").resizable().frame(width: 100,height: 100)
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
        
    }
}

#Preview {
    TermsAndServices()
}
