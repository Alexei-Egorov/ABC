import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.overrideUserInterfaceStyle = .light
        
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
