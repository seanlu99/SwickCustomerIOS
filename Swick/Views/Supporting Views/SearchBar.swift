//
//  SearchBar.swift
//  Swick
//
//  Taken from https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui
//

import SwiftUI

struct SearchBar: View {
    // Properties
    @State private var showCancelButton: Bool = false
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        // Search view
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField(
                    placeholder,
                    text: $text,
                    onEditingChanged: {_ in
                        self.showCancelButton = true
                    }
                )
                .font(SFont.body)
                .foregroundColor(.primary)
                
                Button(action: { self.text = "" }) {
                    Image(systemName: "xmark.circle.fill").opacity(text == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.text = ""
                    self.showCancelButton = false
                }
                .foregroundColor(SColor.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("Ice cream"), placeholder: "Search")
    }
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
