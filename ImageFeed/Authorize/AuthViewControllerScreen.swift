import UIKit

final class AuthViewControllerScreen: UIView {
    
    weak var viewController: AuthViewControllerProtocol?
    
    // MARK: - UI object
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "LogoOfUnsplash")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var authButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didAuthButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "Authenticate"
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .ypBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewController: AuthViewControllerProtocol) {
        self.init()
        self.viewController = viewController
    }
    
    // MARK: - Private methods
    private func addSubViews() {
        addSubviews(logoImageView, authButton)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            authButton.heightAnchor.constraint(equalToConstant: 48),
            authButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            authButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -124)
        ])
    }
    
    @objc private func didAuthButtonTapped() {
        viewController?.showWebviewController()
    }
}
