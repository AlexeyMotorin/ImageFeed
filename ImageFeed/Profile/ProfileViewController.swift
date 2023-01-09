//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алексей Моторин on 30.12.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Private properties
    private var profileScreen = ProfileScreenView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
    }
    
    // MARK: - Private methods
    private func viewSetting() {
        view.backgroundColor = .ypBackground
        addView()
    }
    
    private func addView() {
        view.addSubview(profileScreen)
        
        NSLayoutConstraint.activate([
            profileScreen.topAnchor.constraint(equalTo: view.topAnchor),
            profileScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
