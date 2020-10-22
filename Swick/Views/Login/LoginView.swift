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
                Text("swick")
                    .font(SFont.logo)
                #else
                VStack {
                    Text("swick")
                        .font(SFont.logo)
                    Text("server")
                        .font(SFont.logo)
                }
                #endif
                Text("Food served quick")
                    .font(SFont.body)
                Spacer()
                NavigationLink(
                    destination: LoginEmailView()
                ) {
                    WhiteButtonText(text: "GET STARTED")
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(SFont.gradient.edgesIgnoringSafeArea(.all))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
