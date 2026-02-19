import UIKit

extension HomeViewController {
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        view.addSubview(overlayContainerView)
        overlayContainerView.addSubview(overlayContentView)
        overlayContentView.addSubview(overlayLabel)
        view.addSubview(menuButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            overlayContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuButton.widthAnchor.constraint(equalToConstant: 40),
            menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            overlayContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            overlayContentView.bottomAnchor.constraint(equalTo: menuButton.topAnchor, constant: -12),
            overlayContentView.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            
            overlayLabel.topAnchor.constraint(equalTo: overlayContentView.topAnchor, constant: 12),
            overlayLabel.leadingAnchor.constraint(equalTo: overlayContentView.leadingAnchor, constant: 12),
            overlayLabel.trailingAnchor.constraint(equalTo: overlayContentView.trailingAnchor, constant: -12),
            overlayLabel.bottomAnchor.constraint(equalTo: overlayContentView.bottomAnchor, constant: -12),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
