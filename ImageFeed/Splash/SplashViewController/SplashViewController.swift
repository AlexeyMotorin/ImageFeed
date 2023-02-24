import UIKit
import ProgressHUD

/// Класс проверяет авторизован ли пользователь, в зависимости от этого показывает экран авторизации или tab bar controller
final class SplashViewController: UIViewController {
    
    // MARK: - Private properties
    private struct SplashVCConstants {
        static let authViewControllerIdentifier = "AuthViewController"
        static let tabBarIdentifier = "TabBarViewController"
        static let storyboardName = "Main"
    }
    
    private var splashScreenView = SplashViewControllerScreen()
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: ErrorAlertPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = ErrorAlertPresenter(delegate: self)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
        
    private func setupView() {
        view.backgroundColor = .ypBackground
        setScreenViewOnViewController(view: splashScreenView)
    }
    
    // MARK: - Private methods
    private func switchToAuthViewController() {
        let viewController = getAuthViewController()
        present(viewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration")}
        let tabBarVC = TabBarController()
        window.rootViewController = tabBarVC
    }
    
    private func getAuthViewController() -> UINavigationController {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
    
    private func checkToken() {
        if let token = OAuth2TokenStorage().token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
}

// MARK: AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchToken(code)
    }
    
    private func fetchToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self.switchToAuthViewController()
                self.showErrorAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                self.showErrorAlert()
                self.switchToAuthViewController()
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfile(username) { result in
            switch result {
            case .success(let profileImageURL):
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL" : profileImageURL])
            case .failure(_):
                self.showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        let alertModel = ErrorAlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ok", completion: { [weak self] _ in
                guard let self = self else { return }
                self.checkToken()
            })
        
        alertPresenter?.requestShowResultAlert(alertModel: alertModel)
    }    
}

extension SplashViewController: ErrorAlertPresenterDelegate {
    func showErrorAlert(alertController: UIAlertController?) {
        guard let alertController = alertController else { return }
        present(alertController, animated: true)
    }
}
