import Foundation

struct City: Identifiable, Decodable {
    
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    
    init(imageName: String, title: String, subtitle: String) {
        self.id = UUID()
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
    }
    
    enum CodingKeys: CodingKey {
        case id
        case imageName
        case title
        case subtitle
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
    }
}

extension City {
    static let stub = City(imageName: "Monaco", title: "Monaco", subtitle: "Monaco")
}
