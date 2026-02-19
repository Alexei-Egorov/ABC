import UIKit

final class CityCell: UITableViewCell {
    
    static let cellName = "CityCell"
    
    // MARK: - UI Properties
    
    let cityImageView: UIImageView = {
        let imageView = UIImageView().disableAutoresizingMask()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel().disableAutoresizingMask()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel().disableAutoresizingMask()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        contentView.backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public API
    
    func configure(with city: City) {
        cityImageView.image = UIImage(named: city.imageName)
        titleLabel.text = city.title
        subtitleLabel.text = city.subtitle
    }
}
