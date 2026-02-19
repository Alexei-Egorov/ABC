import UIKit

final class ImageCell: UICollectionViewCell {
    
    static let cellName = "ImageCell"
    
    // MARK: - UI Properties
    
    let imageView: UIImageView = {
        let imageView = UIImageView().disableAutoresizingMask()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public API
    
    func configure(imageName: String) {
        let image = UIImage(named: imageName)
        imageView.image = image
    }
}
