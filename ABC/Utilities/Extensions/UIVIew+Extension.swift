import UIKit

// MARK: - disableAutoresizing

extension UIView {
    
    @discardableResult
    func disableAutoresizingMask() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

// MARK: - Shadow

extension UIView {
    
    func dropShadow(
        x: CGFloat = 0.0,
        y: CGFloat = 2.0,
        color: UIColor = .black,
        opacity: Float = 0.4,
        radius: CGFloat = 4.0
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = radius
    }
}
