import XCTest
import Combine
@testable import ABC

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    private var mockAPIService: MockAPIService!
    private var viewModel: HomeViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        mockAPIService = MockAPIService()
        InjectedValues[\.apiService] = mockAPIService
        viewModel = HomeViewModel()
    }
    
    override func tearDown() async throws {
        mockAPIService = nil
        viewModel = nil
        try await super.tearDown()
    }
    
    // MARK: - Initial State
    
    func test_initialState_isCorrect() {
        XCTAssertTrue(viewModel.cities.isEmpty)
        XCTAssertTrue(viewModel.statistics.isEmpty)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    // MARK: - fetchCountries
    
    func test_fetchCountries_populatesCountriesAndCities() async {
        let cities = [
            City(imageName: "img1", title: "Paris", subtitle: "France"),
            City(imageName: "img2", title: "Lyon", subtitle: "France")
        ]
        let country = Country(countryName: "France", capitalImageName: "paris", cities: cities)
        mockAPIService.fetchCountriesResult = .success(CountriesResponseBody(countries: [country]))
        
        viewModel.fetchCountries()
        
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertEqual(viewModel.cities.count, 2)
        XCTAssertEqual(viewModel.cities.map(\.title), ["Paris", "Lyon"])
    }
    
    func test_fetchCountries_handlesEmptyCountries() async {
        mockAPIService.fetchCountriesResult = .success(CountriesResponseBody(countries: []))
        
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertTrue(viewModel.cities.isEmpty)
        XCTAssertEqual(mockAPIService.fetchCountriesCallCount, 1)
    }
    
    // MARK: - Search Filtering
    
    func test_searchText_filtersCities() async {
        let cities = [
            City(imageName: "img1", title: "Paris", subtitle: "France"),
            City(imageName: "img2", title: "Lyon", subtitle: "France"),
            City(imageName: "img3", title: "London", subtitle: "UK")
        ]
        let country = Country(countryName: "France", capitalImageName: "paris", cities: cities)
        mockAPIService.fetchCountriesResult = .success(CountriesResponseBody(countries: [country]))
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        viewModel.searchText = "par"
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.cities.count, 1)
        XCTAssertEqual(viewModel.cities.first?.title, "Paris")
    }
    
    func test_searchText_emptyRestoresAllCities() async {

        let cities = [
            City(imageName: "img1", title: "Paris", subtitle: "France"),
            City(imageName: "img2", title: "Lyon", subtitle: "France")
        ]
        let country = Country(countryName: "France", capitalImageName: "paris", cities: cities)
        mockAPIService.fetchCountriesResult = .success(CountriesResponseBody(countries: [country]))
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        viewModel.searchText = "par"
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(viewModel.cities.count, 1)
        
        viewModel.searchText = ""
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.cities.count, 2)
    }
    
    func test_searchText_isCaseInsensitive() async {

        let cities = [
            City(imageName: "img1", title: "Paris", subtitle: "France")
        ]
        let country = Country(countryName: "France", capitalImageName: "paris", cities: cities)
        mockAPIService.fetchCountriesResult = .success(CountriesResponseBody(countries: [country]))
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        viewModel.searchText = "PARIS"
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.cities.count, 1)
        XCTAssertEqual(viewModel.cities.first?.title, "Paris")
    }
}
