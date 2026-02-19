import Foundation

final class MockAPIClient: APIService {
    
    // MARK: - Public API
    
    func fetchCountries() async throws -> CountriesResponseBody {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return mockData(for: "Countries")
    }
    
    // MARK: - Helper Methods
    
    private func mockData<T: Decodable>(for resource: String) -> T {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let stubData = try? JSONDecoder().decode(T.self, from: data)else {
            fatalError("Unable to get stub data")
        }
        return stubData
    }
}
