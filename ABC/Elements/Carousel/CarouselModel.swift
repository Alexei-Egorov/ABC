import Foundation
import SwiftUI

struct CarouselItem: Identifiable {
    
    let id: UUID
    let imageName: String
    
    init(imageName: String) {
        self.id = UUID()
        self.imageName = imageName
    }
}
