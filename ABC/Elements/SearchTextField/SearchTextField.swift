import SwiftUI

struct SearchTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UISearchTextField {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = Strings.search
        searchTextField.backgroundColor = .appTFGray
        searchTextField.autocapitalizationType = .none
        searchTextField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textChanged(_:)),
            for: .editingChanged
        )
        return searchTextField
    }
    
    func updateUIView(_ uiView: UISearchTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    final class Coordinator: NSObject {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        @objc func textChanged(_ sender: UISearchTextField) {
            text = sender.text ?? ""
        }
    }
}
