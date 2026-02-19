private struct APIServiceKey: InjectionKey {
    static var currentValue: APIService = {
        let apiClient: APIService = MockAPIClient()
        return apiClient
    }()
}

extension InjectedValues {
    var apiService: APIService {
        get { Self[APIServiceKey.self] }
        set { Self[APIServiceKey.self] = newValue }
    }
}
