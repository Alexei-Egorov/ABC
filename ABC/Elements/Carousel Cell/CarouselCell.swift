import UIKit

protocol CarouselCellDelegate: AnyObject {
    func onCarouselUpdate(index: Int)
}

final class CarouselCell: UITableViewCell {
    
    static let cellName = "CarouselCell"
    
    // MARK: - UI Properties
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        ).disableAutoresizingMask()
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.cellName)
        collectionView.layer.cornerRadius = 15
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl().disableAutoresizingMask()
        pageControl.currentPageIndicatorTintColor = .appBlue
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    // MARK: - Properties
    
    private var imagesNames: [String] = []
    private var currentIndex: Int = 0
    weak var delegate: CarouselCellDelegate?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("Layout isn't flow")
            return
        }
        
        layout.itemSize = bounds.size
    }
    
    // MARK: - Public API
    
    func configure(imagesNames: [String], currentIndex: Int) {
        self.imagesNames = imagesNames
        self.currentIndex = currentIndex
        collectionView.dataSource = self
        collectionView.delegate = self
        pageControl.numberOfPages = imagesNames.count
        pageControl.currentPage = currentIndex
    }
    
    func update() {
        collectionView.reloadData()
    }
}

extension CarouselCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellName, for: indexPath) as! ImageCell
        cell.configure(imageName: imagesNames[indexPath.row])
        return cell
    }
}

extension CarouselCell: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageControl.currentPage = indexPath.item
        delegate?.onCarouselUpdate(index: indexPath.item)
    }
}
