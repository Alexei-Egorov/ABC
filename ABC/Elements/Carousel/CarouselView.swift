import SwiftUI

struct CarouselView: View {
    
    @ObservedObject var viewModel: CarouselViewModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: .zero) {
            TabView(selection: $viewModel.currentIndex) {
                ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                    if let imageName = viewModel.imageForItemAt(index: index) {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .tag(index)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: viewModel.currentIndex) { oldValue, newValue in
                viewModel.updateCurrentIndex(newValue)
            }
            
            HStack(spacing: Constants.dotSpacing) {
                ForEach(0..<viewModel.numberOfItems, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.currentIndex ? Color.blue : Color.gray.opacity(Constants.dotOpacity))
                        .frame(width: Constants.dotSize, height: Constants.dotSize)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, Constants.padding)
        }
    }
}

extension CarouselView {
    
    private enum Constants {
        static let radius: CGFloat = 15
        static let padding: CGFloat = 16
        static let dotSize: CGFloat = 8
        static let dotSpacing: CGFloat = 8
        static let dotOpacity: CGFloat = 0.3
    }
}
