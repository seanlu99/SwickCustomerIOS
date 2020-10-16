//
//  LoginView.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                #if CUSTOMER
                Text("SWICK")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                #else
                Text("SWICK SERVER")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                #endif
                Text("Food served quick")
                Spacer()
                NavigationLink(
                    destination: LoginEmailView()
                ) {
                    BlueText(text: "GET STARTED")
                }
            }
            .padding()
            .background(Color("LightBlue").edgesIgnoringSafeArea(.all))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
