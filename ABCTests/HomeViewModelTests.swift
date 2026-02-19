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
        XCTAssertTrue(viewModel.countries.isEmpty)
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
        
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        
        XCTAssertEqual(viewModel.countries.count, 1)
        XCTAssertEqual(viewModel.countries.first?.countryName, "France")
        XCTAssertEqual(viewModel.cities.count, 2)
        XCTAssertEqual(viewModel.cities.map(\.title), ["Paris", "Lyon"])
        XCTAssertEqual(mockAPIService.fetchCountriesCallCount, 1)
    }
    
    func test_fetchCountries_handlesEmptyCountries() async {
        mockAPIService.fetchCountriesResult = .success(CountriesResponseBody(countries: []))
        
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertTrue(viewModel.countries.isEmpty)
        XCTAssertTrue(viewModel.cities.isEmpty)
        XCTAssertEqual(mockAPIService.fetchCountriesCallCount, 1)
    }
    
    func test_fetchCountries_handlesAPIError() async {
        struct TestError: Error {}
        mockAPIService.fetchCountriesResult = .failure(TestError())
        
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertTrue(viewModel.countries.isEmpty)
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
    
    func test_setStatistics_emptyCities_producesEmptyStatistics() async {

        await viewModel.setStatistics()

        XCTAssertEqual(viewModel.statistics, "")
    }
    
    // MARK: - Carousel Integration
    
    func test_carouselViewModel_hasCorrectItemCountAfterFetch() async {

        let cities = [
            City(imageName: "img1", title: "Paris", subtitle: "France")
        ]
        let country1 = Country(countryName: "France", capitalImageName: "paris", cities: cities)
        let country2 = Country(countryName: "UK", capitalImageName: "london", cities: cities)
        mockAPIService.fetchCountriesResult = .success(
            CountriesResponseBody(countries: [country1, country2])
        )

        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertEqual(viewModel.carouselViewModel.numberOfItems, 2)
    }
    
    func test_carouselIndexUpdate_changesDisplayedCities() async {

        let frenchCities = [
            City(imageName: "img1", title: "Paris", subtitle: "France"),
            City(imageName: "img2", title: "Lyon", subtitle: "France")
        ]
        let ukCities = [
            City(imageName: "img3", title: "London", subtitle: "UK"),
            City(imageName: "img4", title: "Manchester", subtitle: "UK")
        ]
        let country1 = Country(countryName: "France", capitalImageName: "paris", cities: frenchCities)
        let country2 = Country(countryName: "UK", capitalImageName: "london", cities: ukCities)
        mockAPIService.fetchCountriesResult = .success(
            CountriesResponseBody(countries: [country1, country2])
        )
        viewModel.fetchCountries()
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertEqual(viewModel.cities.map(\.title), ["Paris", "Lyon"])

        viewModel.carouselViewModel.updateCurrentIndex(1)
        
        XCTAssertEqual(viewModel.cities.map(\.title), ["London", "Manchester"])
    }
}
