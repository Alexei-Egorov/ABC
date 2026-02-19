import UIKit

extension CityHeader {
    
    func setupConstraints() {
        
        contentView.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            searchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchTextField.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
