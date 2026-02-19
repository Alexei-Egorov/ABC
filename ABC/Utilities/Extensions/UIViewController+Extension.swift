import UIKit

// MARK: - addHidingKeyboardOnTap

extension UIViewController {
    
    func addHidingKeyboardOnTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
