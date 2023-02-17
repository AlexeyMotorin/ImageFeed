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
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            })
            updateAvatar()
    }
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .ypBackground
        setScreenViewOnViewController(view: profileScreenView)
    }
    
    private func updateProfileDetails(profile: Profile) {
        profileScreenView.updateProfile(from: profile)
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        profileScreenView.updateAvatar(url)
    }
}
