//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Моторин on 30.12.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Private properties
    private var profileScreenView = ProfileScreenView()
    private let token = OAuth2TokenStorage().token
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .ypBackground
        addView()
        
        if let token {
            ProfileService.shared.fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.profileScreenView.setProfile(from: profile)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    private func addView() {
        view.addSubview(profileScreenView)
        
        NSLayoutConstraint.activate([
            profileScreenView.topAnchor.constraint(equalTo: view.topAnchor),
            profileScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
