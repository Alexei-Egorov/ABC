protocol APIService {
    
    func fetchCountries() async throws -> CountriesResponseBody
}
