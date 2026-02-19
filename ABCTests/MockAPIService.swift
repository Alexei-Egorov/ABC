import Foundation
@testable import ABC

/// Mock APIService for unit testing HomeViewModel
final class MockAPIService: APIService {
    
    var fetchCountriesResult: Result<CountriesResponseBody, Error> = .success(
        CountriesResponseBody(countries: [])
    )
    var fetchCountriesCallCount = 0
    
    func fetchCountries() async throws -> CountriesResponseBody {
        fetchCountriesCallCount += 1
        switch fetchCountriesResult {
        case .success(let body):
            return body
        case .failure(let error):
            throw error
        }
    }
}
