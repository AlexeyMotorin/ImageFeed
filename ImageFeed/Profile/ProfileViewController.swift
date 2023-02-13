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
    private let profileService = ProfileService.shared
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .ypBackground
        addView()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
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
    
    private func updateProfileDetails(profile: Profile) {
        profileScreenView.updateProfile(from: profile)
    }
}
