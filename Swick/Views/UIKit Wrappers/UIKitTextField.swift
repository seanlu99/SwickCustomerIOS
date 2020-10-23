//
//  UIKitTextField.swift
//  Swick
//
//  Taken from: https://gist.github.com/shaps80/8a3170160f80cfdc6e8179fa0f5e1621
//

import SwiftUI

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 5) {
            UIKitTextField("Placeholder", text: .constant(""))
                .font(.system(.body, design: .serif))
                .border(Color.black, width: 1)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}

struct UIKitTextField: View {

    @Environment(\.layoutDirection) private var layoutDirection
    @Binding private var text: String
    @State private var calculatedHeight: CGFloat = 44
    @State private var isEmpty: Bool = false

    private var title: String
    private var onEditingChanged: (() -> Void)?
    private var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
    private var onCommit: (() -> Void)?

    private var placeholderFont: Font = .body
    private var placeholderAlignment: TextAlignment = .leading
    private var foregroundColor: UIColor = .label
    private var autocapitalization: UITextAutocapitalizationType = .sentences
    private var multilineTextAlignment: NSTextAlignment = .left
    private var font: UIFont = .preferredFont(forTextStyle: .body)
    private var returnKeyType: UIReturnKeyType?
    private var clearsOnInsertion: Bool = false
    private var autocorrection: UITextAutocorrectionType = .default
    private var truncationMode: NSLineBreakMode = .byTruncatingTail
    private var isSecure: Bool = false
    private var isEditable: Bool = true
    private var isSelectable: Bool = true
    private var isScrollingEnabled: Bool = false
    private var enablesReturnKeyAutomatically: Bool?
    private var autoDetectionTypes: UIDataDetectorTypes = []
    private var whichKeyboard: UIKeyboardType = .default
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text }) {
            self.text = $0
            self.isEmpty = $0.isEmpty
        }
    }

    init(_ title: String,
         text: Binding<String>,
         shouldEditInRange: ((Range<String.Index>, String) -> Bool)? = nil,
         onEditingChanged: (() -> Void)? = nil,
         onCommit: (() -> Void)? = nil) {
        self.title = title

        _text = text
        _isEmpty = State(initialValue: self.text.isEmpty)

        self.onCommit = onCommit
        self.shouldEditInRange = shouldEditInRange
        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        SwiftUITextView(internalText,
                        foregroundColor: foregroundColor,
                        font: font,
                        multilineTextAlignment: multilineTextAlignment,
                        autocapitalization: autocapitalization,
                        returnKeyType: returnKeyType,
                        clearsOnInsertion: clearsOnInsertion,
                        autocorrection: autocorrection,
                        truncationMode: truncationMode,
                        isSecure: isSecure,
                        isEditable: isEditable,
                        isSelectable: isSelectable,
                        isScrollingEnabled: isScrollingEnabled,
                        enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
                        autoDetectionTypes: autoDetectionTypes,
                        calculatedHeight: $calculatedHeight,
                        shouldEditInRange: shouldEditInRange,
                        onEditingChanged: onEditingChanged,
                        onCommit: onCommit,
                        whichKeyboard: whichKeyboard)
            .frame(
                minHeight: isScrollingEnabled ? 0 : calculatedHeight,
                maxHeight: isScrollingEnabled ? .infinity : calculatedHeight
        )
            .background(placeholderView, alignment: .leading)
    }

    var placeholderView: some View {
        Group {
            if isEmpty {
                Text(title)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(placeholderAlignment)
                    .font(placeholderFont)
            }
        }
    }

}

extension UIKitTextField {

    func autoDetectDataTypes(_ types: UIDataDetectorTypes) -> UIKitTextField {
        var view = self
        view.autoDetectionTypes = types
        return view
    }

    func foregroundColor(_ color: UIColor) -> UIKitTextField {
        var view = self
        view.foregroundColor = color
        return view
    }

    func autocapitalization(_ style: UITextAutocapitalizationType) -> UIKitTextField {
        var view = self
        view.autocapitalization = style
        return view
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> UIKitTextField {
        var view = self
        view.placeholderAlignment = alignment
        switch alignment {
        case .leading:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.multilineTextAlignment = .center
        }
        return view
    }

    func font(_ font: UIFont) -> UIKitTextField {
        var view = self
        view.font = font
        return view
    }

    func placeholderFont(_ font: Font) -> UIKitTextField {
        var view = self
        view.placeholderFont = font
        return view
    }


    func clearOnInsertion(_ value: Bool) -> UIKitTextField {
        var view = self
        view.clearsOnInsertion = value
        return view
    }

    func disableAutocorrection(_ disable: Bool?) -> UIKitTextField {
        var view = self
        if let disable = disable {
            view.autocorrection = disable ? .no : .yes
        } else {
            view.autocorrection = .default
        }
        return view
    }

    func isEditable(_ isEditable: Bool) -> UIKitTextField {
        var view = self
        view.isEditable = isEditable
        return view
    }

    func isSelectable(_ isSelectable: Bool) -> UIKitTextField {
        var view = self
        view.isSelectable = isSelectable
        return view
    }

    func enableScrolling(_ isScrollingEnabled: Bool) -> UIKitTextField {
        var view = self
        view.isScrollingEnabled = isScrollingEnabled
        return view
    }

    func returnKey(_ style: UIReturnKeyType?) -> UIKitTextField {
        var view = self
        view.returnKeyType = style
        return view
    }

    func automaticallyEnablesReturn(_ value: Bool?) -> UIKitTextField {
        var view = self
        view.enablesReturnKeyAutomatically = value
        return view
    }

    func truncationMode(_ mode: Text.TruncationMode) -> UIKitTextField {
        var view = self
        switch mode {
        case .head: view.truncationMode = .byTruncatingHead
        case .tail: view.truncationMode = .byTruncatingTail
        case .middle: view.truncationMode = .byTruncatingMiddle
        @unknown default:
            fatalError("Unknown text truncation mode")
        }
        return view
    }
    
    func keyboardType(_ keyboardType: UIKeyboardType) -> UIKitTextField {
        var view = self
        view.whichKeyboard = keyboardType
        return view
    }
}

private struct SwiftUITextView: UIViewRepresentable {

    @Binding private var text: String
    @Binding private var calculatedHeight: CGFloat

    private var onEditingChanged: (() -> Void)?
    private var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
    private var onCommit: (() -> Void)?

    private let foregroundColor: UIColor
    private let autocapitalization: UITextAutocapitalizationType
    private let multilineTextAlignment: NSTextAlignment
    private let font: UIFont
    private let returnKeyType: UIReturnKeyType?
    private let clearsOnInsertion: Bool
    private let autocorrection: UITextAutocorrectionType
    private let truncationMode: NSLineBreakMode
    private let isSecure: Bool
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool
    private let enablesReturnKeyAutomatically: Bool?
    private var autoDetectionTypes: UIDataDetectorTypes = []
    private var whichKeyboard: UIKeyboardType

    init(_ text: Binding<String>,
         foregroundColor: UIColor,
         font: UIFont,
         multilineTextAlignment: NSTextAlignment,
         autocapitalization: UITextAutocapitalizationType,
         returnKeyType: UIReturnKeyType?,
         clearsOnInsertion: Bool,
         autocorrection: UITextAutocorrectionType,
         truncationMode: NSLineBreakMode,
         isSecure: Bool,
         isEditable: Bool,
         isSelectable: Bool,
         isScrollingEnabled: Bool,
         enablesReturnKeyAutomatically: Bool?,
         autoDetectionTypes: UIDataDetectorTypes,
         calculatedHeight: Binding<CGFloat>,
         shouldEditInRange: ((Range<String.Index>, String) -> Bool)?,
         onEditingChanged: (() -> Void)?,
         onCommit: (() -> Void)?,
         whichKeyboard: UIKeyboardType) {
        _text = text
        _calculatedHeight = calculatedHeight

        self.onCommit = onCommit
        self.shouldEditInRange = shouldEditInRange
        self.onEditingChanged = onEditingChanged

        self.foregroundColor = foregroundColor
        self.font = font
        self.multilineTextAlignment = multilineTextAlignment
        self.autocapitalization = autocapitalization
        self.returnKeyType = returnKeyType
        self.clearsOnInsertion = clearsOnInsertion
        self.autocorrection = autocorrection
        self.truncationMode = truncationMode
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.autoDetectionTypes = autoDetectionTypes
        self.whichKeyboard = whichKeyboard

        makeCoordinator()
    }

    func makeUIView(context: Context) -> UIKitTextView {
        let view = UIKitTextView()
        view.delegate = context.coordinator
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.backgroundColor = UIColor.clear
        view.adjustsFontForContentSizeCategory = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }

    func updateUIView(_ view: UIKitTextView, context: Context) {
        view.text = text
        view.font = font
        view.textAlignment = multilineTextAlignment
        view.textColor = foregroundColor
        view.autocapitalizationType = autocapitalization
        view.autocorrectionType = autocorrection
        view.isEditable = isEditable
        view.isSelectable = isSelectable
        view.isScrollEnabled = isScrollingEnabled
        view.dataDetectorTypes = autoDetectionTypes
        view.keyboardType = whichKeyboard

        if let value = enablesReturnKeyAutomatically {
            view.enablesReturnKeyAutomatically = value
        } else {
            view.enablesReturnKeyAutomatically = onCommit == nil ? false : true
        }

        if let returnKeyType = returnKeyType {
            view.returnKeyType = returnKeyType
        } else {
            view.returnKeyType = onCommit == nil ? .default : .done
        }
        
        if !context.coordinator.didBecomeFirstResponder  {
            view.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }

        SwiftUITextView.recalculateHeight(view: view, result: $calculatedHeight)
    }

    @discardableResult func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            calculatedHeight: $calculatedHeight,
            shouldEditInRange: shouldEditInRange,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.width, height: .greatestFiniteMagnitude))

        guard result.wrappedValue != newSize.height else { return }
        DispatchQueue.main.async { // call in next render cycle.
            result.wrappedValue = newSize.height
        }
    }

}

private extension SwiftUITextView {

    final class Coordinator: NSObject, UITextViewDelegate {

        private var originalText: String = ""
        private var text: Binding<String>
        private var calculatedHeight: Binding<CGFloat>
        var didBecomeFirstResponder = false


        var onCommit: (() -> Void)?
        var onEditingChanged: (() -> Void)?
        var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?

        init(text: Binding<String>,
             calculatedHeight: Binding<CGFloat>,
             shouldEditInRange: ((Range<String.Index>, String) -> Bool)?,
             onEditingChanged: (() -> Void)?,
             onCommit: (() -> Void)?) {
            self.text = text
            self.calculatedHeight = calculatedHeight
            self.shouldEditInRange = shouldEditInRange
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textViewDidBeginEditing(_ UIKitTextField: UITextView) {
            originalText = text.wrappedValue
        }

        func textViewDidChange(_ UIKitTextField: UITextView) {
            text.wrappedValue = UIKitTextField.text
            SwiftUITextView.recalculateHeight(view: UIKitTextField, result: calculatedHeight)
            onEditingChanged?()
        }

        func textView(_ UIKitTextField: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard let oldText = UIKitTextField.text, let r = Range(range, in: oldText) else {
                return true
            }
            if UIKitTextField.keyboardType == .decimalPad {
                let newText = oldText.replacingCharacters(in: r, with: text)
                let isNumeric = newText.isEmpty || (Double(newText) != nil)
                let numberOfDots = newText.components(separatedBy: ".").count - 1
                
                let numberOfDecimalDigits: Int
                if let dotIndex = newText.firstIndex(of: ".") {
                    numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                } else {
                    numberOfDecimalDigits = 0
                }
                
                return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
            }
            
            if onCommit != nil, text == "\n" {
                onCommit?()
                originalText = UIKitTextField.text
                return false
            }
            return true
        }

        func textViewDidEndEditing(_ UIKitTextField: UITextView) {
            // this check is to ensure we always commit text when we're not using a closure
            if onCommit != nil {
                text.wrappedValue = originalText
            }
        }
    }
}

private final class UIKitTextView: UITextView {

    override var keyCommands: [UIKeyCommand]? {
        return (super.keyCommands ?? []) + [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:)))
        ]
    }

    @objc private func escape(_ sender: Any) {
        resignFirstResponder()
    }

}
