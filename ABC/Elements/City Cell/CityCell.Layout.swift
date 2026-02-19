import UIKit

extension CityCell {
    
    func setupConstraints() {
        
        let containerView = UIView().disableAutoresizingMask()
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = .appCyan
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        
        containerView.addSubview(cityImageView)
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            cityImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            cityImageView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -5),
            cityImageView.widthAnchor.constraint(equalToConstant: 80),
            cityImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: cityImageView.centerYAnchor, constant: -2),
            titleLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -5)
        ])
        
        containerView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: cityImageView.centerYAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 5),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -5),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -5)
        ])
    }
}
