
import UIKit
import Kingfisher

final class ProfileScreenView: UIView {
    
    weak var viewController: ProfileViewControllerProtocol?
    
    // MARK: - UI object
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var photoAndExitButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var lablesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "placeholder")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.addTarget(self, action: #selector(didExitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypWhite?.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
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
    
    convenience init(viewController: ProfileViewControllerProtocol) {
        self.init()
        self.viewController = viewController
    }
    
    // MARK: - Public methods
    func updateProfile(from profile: Profile?) {
        guard let profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar(_ url: URL) {
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.profileImageView.image = value.image
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
            case .failure(_):
                self.viewController?.showAlertGetAvatarError()
            }
        }
    }
    
    // MARK: - Private methods
    private func addSabViews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(photoAndExitButtonStackView)
        stackView.addArrangedSubview(lablesStackView)
        
        photoAndExitButtonStackView.addArrangedSubview(profileImageView)
        photoAndExitButtonStackView.addArrangedSubview(exitButton)
        
        lablesStackView.addArrangedSubview(nameLabel)
        lablesStackView.addArrangedSubview(loginNameLabel)
        lablesStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func activateConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 76),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            photoAndExitButtonStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            photoAndExitButtonStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didExitButtonTapped() {
        // выход из аккаунта
    }
}
