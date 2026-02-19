import SwiftUI

@main
struct ABCApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
                .preferredColorScheme(.light)
                .background(Color.appCyanLight)
        }
    }
}
