import UIKit
import ProgressHUD

/// Класс проверяет авторизован ли пользователь, в зависимости от этого показывает экран авторизации или tab bar controller
final class SplashViewController: UIViewController {
    
    // MARK: - Private properties
    private struct SplashVCConstants {
        static let authenticationScreenIdentifier = "ShowAuthenticationScreenIdentifier"
        static let tabBarIdentifier = "TabBarViewController"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OAuth2TokenStorage().token != nil ? switchToTabBarController() : switchToAuthViewController()
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
        ProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.switchToTabBarController()
                ProgressHUD.dismiss()
                print(token)
            case .failure(let error):
                ProgressHUD.dismiss()
                print(error)
            }
        }
    }
}
