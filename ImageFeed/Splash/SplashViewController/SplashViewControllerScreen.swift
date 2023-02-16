//
//  SplashViewControllerScreen.swift
//  ImageFeed
//
//  Created by Алексей Моторин on 16.02.2023.
//

import UIKit

class SplashViewControllerScreen: UIView {
    // MARK: - UI object
 
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "LogoOfUnsplash")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .ypBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        addSabViews()
        activateConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addSabViews() {
        self.addSubview(logoImageView)
    }
    
    private func activateConstraint() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func didExitButtonTapped() {
        // выход из аккаунта
    }
}
