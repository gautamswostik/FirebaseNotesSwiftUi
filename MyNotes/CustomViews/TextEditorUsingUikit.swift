import SwiftUI
import UIKit

struct CustomTextArea: UIViewRepresentable {
    @Binding var text: String
    var onChanged:((String) -> Void)
    

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text , onChanged: onChanged)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        var onChanged: ((String) -> Void)
        
        init(text: Binding<String> , onChanged:@escaping ((String) -> Void)) {
            _text = text
            self.onChanged = onChanged
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
            onChanged(text)
        }
    }
}
