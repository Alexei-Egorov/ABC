import Foundation
import SwiftUI
import Combine

final class CarouselViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var items: [CarouselItem]
    @Published var currentIndex: Int = 0
    
    var onIndexUpdate: ((Int) -> ())?
    
    var numberOfItems: Int {
        items.count
    }
    
    // MARK: - Initialization
    
    init(items: [CarouselItem]) {
        self.items = items
    }
    
    // MARK: - Public Methods
    
    func imageForItemAt(index: Int) -> String? {
        guard index >= 0 && index < items.count else {
            return nil
        }
        return items[index].imageName
    }
    
    func updateCurrentIndex(_ index: Int) {
        guard index >= 0 && index < items.count else {
            return
        }
        currentIndex = index
        onIndexUpdate?(index)
    }
}
