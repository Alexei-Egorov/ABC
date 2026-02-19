import SwiftUI

struct TextOverlayView: View {
    
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: Constants.fontSize))
            .padding(Constants.padding)
            .background(
                RoundedRectangle(cornerRadius: Constants.radius)
                    .fill(Color.white)
            )
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension TextOverlayView {
    
    private enum Constants {
        static let fontSize: CGFloat = 15
        static let radius: CGFloat = 12
        static let padding: CGFloat = 12
    }
}
