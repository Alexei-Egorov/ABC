import Foundation

struct Country: Identifiable, Decodable {
    
    let id: UUID
    let countryName: String
    let capitalImageName: String
    let cities: [City]
    
    init(countryName: String, capitalImageName: String, cities: [City]) {
        self.id = UUID()
        self.countryName = countryName
        self.capitalImageName = capitalImageName
        self.cities = cities
    }
    
    enum CodingKeys: CodingKey {
        case id
        case countryName
        case capitalImageName
        case cities
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.countryName = try container.decode(String.self, forKey: .countryName)
        self.capitalImageName = try container.decode(String.self, forKey: .capitalImageName)
        self.cities = try container.decode([City].self, forKey: .cities)
    }
}
