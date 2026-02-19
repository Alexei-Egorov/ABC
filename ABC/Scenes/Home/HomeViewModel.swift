import UIKit
import Combine

final class HomeViewModel {
    
    // MARK: - Properties
    
    @Injected(\.apiService) private var apiService: APIService
    
    private var countries: [Country] = []
    private var allCities: [City] = []
    @Published private(set) var cities: [City] = []
    
    var selectedCountryIndex: Int = 0
    @Published var searchText: String = ""
    @Published var statistics: String = ""
    @Published private(set) var isLoading = false
    
    private var fetchTask: Task<Void, Error>?
    private var subscriptions = Set<AnyCancellable>()
    
    var imagesNames: [String] {
        countries.map(\.capitalImageName)
    }
    
    var numberOfItems: Int {
        cities.count
    }
    
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
    
    // MARK: - Public API
    
    func fetchCountries() {
        fetchTask?.cancel()
        
        fetchTask = Task {
            isLoading = true
            defer { isLoading = false }
            countries = try await apiService.fetchCountries().countries
            guard let firstCountry = countries.first else { return }
            allCities = firstCountry.cities
            cities = firstCountry.cities
        }
    }
    
    func getCity(at indexPath: IndexPath) -> City {
        cities[indexPath.row]
    }
    
    func selectCountry(at index: Int) {
        guard selectedCountryIndex != index else { return }
        selectedCountryIndex = index
        allCities = countries[index].cities
        cities = countries[index].cities
    }
    
    func setStatistics() {
        Task {
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
    }
    
    // MARK: - deinit
    
    deinit {
        fetchTask?.cancel()
    }
}
