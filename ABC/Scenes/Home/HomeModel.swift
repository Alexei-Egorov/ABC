extension HomeViewController {
    
    enum Section: Int {
        case carousel
        case main
    }

    struct CarouselItem: Hashable, Sendable {
        let imagesNames: [String]
    }

    nonisolated
    enum Item: Hashable {
        case carousel(CarouselItem)
        case city(City)
    }
}
