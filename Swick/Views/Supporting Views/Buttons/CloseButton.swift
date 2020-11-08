//
//  CloseButton.swift
//  Swick
//
//  Created by Sean Lu on 11/7/20.
//

import SwiftUI

struct CloseButton: ViewModifier  {
    // Properties
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .navigationBarItems(
                trailing:
                    Button(action: {isPresented.toggle()}) {
                        SystemImage(name: "xmark", width: 20, height: 20)
                    }
            )
    }
}

extension View {
    func closeButton(_ isPresented: Binding<Bool>) -> some View {
        self.modifier(CloseButton(isPresented: isPresented))
    }
}

