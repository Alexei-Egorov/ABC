import SwiftUI

struct HomeView: View {

    @ObservedObject private var viewModel: HomeViewModel
    @State private var statisticsText: String = ""
    @State private var showOverlay = false
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    CarouselView(viewModel: viewModel.carouselViewModel)
                        .frame(height: Constants.carouselHeight)
                    
                    Section {
                        LazyVStack(spacing: Constants.interitemSpacing) {
                            ForEach(viewModel.cities) { city in
                                CityView(viewModel: .init(city: city))
                            }
                        }
                    } header: {
                        SearchTextField(text: $viewModel.searchText)
                            .frame(height: Constants.textFieldHeight)
                    }
                }
                .padding(Constants.generalPadding)
            }
            
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                    
                    if showOverlay {
                        TextOverlayView(text: viewModel.statistics)
                    }

                    Button {
                        showOverlay.toggle()
                        
                        if showOverlay {
                            Task {
                                await viewModel.setStatistics()
                            }
                        }
                    } label: {
                        Circle()
                            .fill(Color.appBlue)
                            .frame(width: Constants.bottomButtonSize, height: Constants.bottomButtonSize)
                            .overlay {
                                Image(systemName: ImageNameConstants.ellipsis)
                                    .rotationEffect(.degrees(Constants.buttonImageRotationDegrees))
                                    .foregroundColor(.white)
                            }
                            .shadow(radius: Constants.shadowRadius)
                    }
                }
                .padding(Constants.generalPadding)
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.fetchCountries()
        }
    }
    
    private enum Constants {
        static let carouselHeight: CGFloat = 250
        static let textFieldHeight: CGFloat = 40
        static let interitemSpacing: CGFloat = 4
        static let generalPadding: CGFloat = 20
        static let bottomButtonSize: CGFloat = 40
        static let shadowRadius: CGFloat = 4
        static let buttonImageRotationDegrees: CGFloat = 90
    }
}

#Preview {
    HomeView(viewModel: .init())
}
