import SwiftUI

struct CityView: View {
    
    let viewModel: CityViewModel
    
    var body: some View {
        HStack {
            Image(viewModel.imageName)
                .resizable()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.system(size: Constants.titleFontSize, weight: .semibold))
                Text(viewModel.subtitle)
                    .font(.system(size: Constants.subtitleFontSize))
            }
            Spacer()
        }
        .padding(Constants.padding)
        .background(Color.appCyan)
        .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
    }
}

#Preview {
    let stub = City(imageName: "Monaco", title: "Monaco", subtitle: "Monaco")
    CityView(viewModel: .init(city: stub))
}

extension CityView {
    
    private enum Constants {
        static let titleFontSize: CGFloat = 16
        static let subtitleFontSize: CGFloat = 14
        static let imageSize: CGFloat = 80
        static let radius: CGFloat = 15
        static let padding: CGFloat = 6
    }
}
