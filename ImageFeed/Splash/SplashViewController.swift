import UIKit
import ProgressHUD

/// Класс проверяет авторизован ли пользователь, в зависимости от этого показывает экран авторизации или tab bar controller
final class SplashViewController: UIViewController {
    
    // MARK: - Private properties
    private struct SplashVCConstants {
        static let authenticationScreenIdentifier = "ShowAuthenticationScreenIdentifier"
        static let tabBarIdentifier = "TabBarViewController"
    }
    
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AuthErrorAlertPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alertPresenter = AuthErrorAlertPresenter(delegate: self)
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    // MARK: - Override methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SplashVCConstants.authenticationScreenIdentifier {
            guard let navController = segue.destination as? UINavigationController,
                  let viewController = navController.viewControllers.first as? AuthViewController else {
                fatalError("Ошибка сигвея \(SplashVCConstants.authenticationScreenIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private methods
    private func switchToAuthViewController() {
        performSegue(withIdentifier: SplashVCConstants.authenticationScreenIdentifier, sender: nil)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration")}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: SplashVCConstants.tabBarIdentifier)
        window.rootViewController = tabBarVC
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
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
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
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func showErrorAlert() {
        let alertModel = AuthErrorAlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ok")
        
        alertPresenter?.requestShowResultAlert(alertModel: alertModel)
    }
}

extension SplashViewController: AuthErrorAlertPresenterDelegate {
    func showErrorAlert(alertController: UIAlertController?) {
        guard let alertController = alertController else { return }
        present(alertController, animated: true)
    }
}
