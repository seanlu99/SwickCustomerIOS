//
//  ModalHackView.swift
//  Swick
//
//  Taken from https://gist.github.com/mobilinked/9b6086b3760bcf1e5432932dad0813c0
//

import SwiftUI

/// Prevent sheet dismissal by draging down (and tapping outside the sheet on iPad)
/// The "presentationMode.wrappedValue.dismiss()" still works
struct ModalHackView: UIViewControllerRepresentable {
    var dismissable: () -> Bool = { false }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ModalHackView>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ModalHackView>) {
        rootViewController(of: uiViewController).presentationController?.delegate = context.coordinator
    }
    private func rootViewController(of uiViewController: UIViewController) -> UIViewController {
        if let parent = uiViewController.parent {
            return rootViewController(of: parent)
        }
        else {
            return uiViewController
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(dismissable: dismissable)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var dismissable: () -> Bool = { false }
        
        init(dismissable: @escaping () -> Bool) {
            self.dismissable = dismissable
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            dismissable()
        }
    }
}

/// make the call the SwiftUI style:
/// view.allowAutoDismiss(...)
extension View {
    public func allowAutoDismiss(_ dismissable: @escaping () -> Bool) -> some View {
        self
            .background(ModalHackView(dismissable: dismissable))
    }
}
