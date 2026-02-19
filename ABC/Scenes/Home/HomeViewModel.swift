import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Injected(\.apiService) private var apiService: APIService
    
    @Published private(set) var countries: [Country] = []
    @Published private(set) var cities: [City] = []
    @Published private(set) var statistics: String = ""
    @Published var searchText: String = ""
    @Published private(set) var isLoading = false
    
    private var allCities: [City] = []
    private var fetchTask: Task<Void, Error>?
    private var hasLoaded = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    lazy var carouselViewModel: CarouselViewModel = {
        getCarouselViewModel()
    }()
    
    // MARK: - Initialization
    
    init() {
        setupSubscriptions()
    }
    
    // MARK: - Setup Methods
    
    private func setupSubscriptions() {
        $searchText
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink
        { [weak self] searchText in
            guard let self else { return }
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard !query.isEmpty else {
                self.cities = allCities
                return
            }
            self.cities = self.allCities.filter({ $0.title.lowercased().contains(query) })
        }.store(in: &subscriptions)
    }
    
    // MARK: - Public Methods
    
    func fetchCountries() {
        guard !hasLoaded else { return }
        
        fetchTask?.cancel()
        
        fetchTask = Task {
            isLoading = true
            defer { isLoading = false }
            let countries = try await apiService.fetchCountries().countries
            self.countries = countries
            guard let firstCountry = countries.first else { return }
            allCities = firstCountry.cities
            cities = firstCountry.cities
            carouselViewModel = getCarouselViewModel()
        }
    }
    
    func setStatistics() async {
        var counts: [Character: Int] = [:]
        let strings = cities
            .map(\.title)
            .joined()
            .lowercased()
        
        for char in strings {
            guard char.isLetter else { continue }
            counts[char, default: 0] += 1
        }
        
        statistics = counts
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { "\($0.key) = \($0.value)" }
            .joined(separator: "\n")
    }
    
    // MARK: - Helper Methods
    
    private func updateCities(_ index: Int) {
        allCities = countries[index].cities
        cities = countries[index].cities
    }
    
    private func getCarouselViewModel() -> CarouselViewModel {
        let carouselItems = countries.map({ CarouselItem(imageName: $0.capitalImageName) })
        let carouselViewModel = CarouselViewModel(items: carouselItems)
        carouselViewModel.onIndexUpdate = { [weak self] index in
            self?.updateCities(index)
        }
        return carouselViewModel
    }
    
    // MARK: - deinit
    
    deinit {
        fetchTask?.cancel()
    }
}
