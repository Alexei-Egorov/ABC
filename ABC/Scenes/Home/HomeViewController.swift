import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    
    let tableView: UITableView = {
        let tableView = UITableView().disableAutoresizingMask()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CityHeader.self, forHeaderFooterViewReuseIdentifier: CityHeader.cellname)
        tableView.register(CarouselCell.self, forCellReuseIdentifier: CarouselCell.cellName)
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.cellName)
        return tableView
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system).disableAutoresizingMask()
        button.backgroundColor = .appBlue
        button.tintColor = .white
        button.setTitle("⋮", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.dropShadow()
        return button
    }()
    
    let overlayContainerView: UIView = {
        let view = UIView().disableAutoresizingMask()
        view.backgroundColor = .clear
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    let overlayContentView: UIView = {
        let view = UIView().disableAutoresizingMask()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let overlayLabel: UILabel = {
        let label = UILabel().disableAutoresizingMask()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView().disableAutoresizingMask()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    
    // MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubscriptions()
        setupActions()
        viewModel.fetchCountries()
    }

    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = .appCyanLight
        
        configureDataSource()
        tableView.delegate = self
        addHidingKeyboardOnTap()
    }
    
    private func setupActions() {
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOverlayBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        overlayContainerView.addGestureRecognizer(tapGesture)
    }
    
    private func setupSubscriptions() {
        
        viewModel
            .$cities
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink
        { [weak self] cities in
            self?.applySnapshot(for: cities)
        }.store(in: &subscriptions)
        
        viewModel
            .$statistics
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink
        { [weak self] statistics in
            self?.overlayLabel.text = statistics
        }.store(in: &subscriptions)
        
        viewModel
            .$isLoading
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink
        { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &subscriptions)
    }
    
    // MARK: - Helper Methods
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(
                tableView: tableView
            ) { [weak self] _, indexPath, _ in
                switch indexPath.section {
                case 0: return self?.getCarouselCell()
                case 1: return self?.getCityCell(for: indexPath)
                default: return nil
                }
            }
    }
    
    private func applySnapshot(for cities: [City]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.carousel, .main])
        
        snapshot.appendItems(
            [.carousel(CarouselItem(imagesNames: viewModel.imagesNames))],
            toSection: .carousel
        )
        snapshot.appendItems(
            cities.map { Item.city($0) },
            toSection: .main
        )
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func getCarouselCell() -> CarouselCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarouselCell.cellName) as! CarouselCell
        
        cell.configure(
            imagesNames: viewModel.imagesNames,
            currentIndex: viewModel.selectedCountryIndex
        )
        cell.delegate = self
        
        return cell
    }
    
    private func getCityCell(for indexPath: IndexPath) -> CityCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.cellName) as! CityCell
        let city = viewModel.getCity(at: indexPath)
        cell.configure(with: city)
        return cell
    }
    
    // MARK: - Actions
    
    @objc private func didTapMenuButton() {
        if overlayContainerView.isHidden {
            showOverlay()
        } else {
            hideOverlay()
        }
    }
    
    @objc private func handleOverlayBackgroundTap() {
        hideOverlay()
    }
    
    private func showOverlay() {
        viewModel.setStatistics()
        overlayContainerView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.overlayContainerView.alpha = 1
        }
    }
    
    private func hideOverlay() {
        guard !overlayContainerView.isHidden else { return }
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.overlayContainerView.alpha = 0
            },
            completion: { _ in
                self.overlayContainerView.isHidden = true
            }
        )
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? 55 : .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CityHeader.cellname) as! CityHeader
        header.searchTextField.delegate = self
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: overlayContainerView)
        return !overlayContentView.frame.contains(location)
    }
}

extension HomeViewController: CityHeaderDelegate {
    func textDidChange(text: String) {
        guard viewModel.searchText != text else { return }
        viewModel.searchText = text
    }
}

extension HomeViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.searchText = textField.text ?? ""
    }
}

extension HomeViewController: CarouselCellDelegate {
    
    func onCarouselUpdate(index: Int) {
        viewModel.selectCountry(at: index)
    }
}
