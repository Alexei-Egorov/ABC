import Foundation

final class CityViewModel {
    
    // MARK: - Properties
    
    private let city: City
    
    var imageName: String {
        city.imageName
    }
    
    var title: String {
        city.title
    }
    
    var subtitle: String {
        city.subtitle
    }
    
    // MARK: - Initialization
    
    init(city: City) {
        self.city = city
    }
}
