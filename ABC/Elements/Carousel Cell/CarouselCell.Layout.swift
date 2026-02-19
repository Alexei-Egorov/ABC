import UIKit

extension CarouselCell {
    
    func setupConstraints() {
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: 16),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
