import UIKit
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    func showAlertGetAvatarError(alertModel: ErrorAlertModel)
    func logoutProfile(alertModel: LogoutAlertModel)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    private var profileScreenView: ProfileView!
    private var errorAlertPresenter: ErrorAuthAlertPresenterProtocol?
    private var logoutAlertPresenter: LogoutAlertPresenterProtocol?
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profileScreenView = ProfileView(frame: .zero, viewController: self)
        errorAlertPresenter = ErrorAuthAlertPresenter(delegate: self)
        logoutAlertPresenter = LogoutAlertPresenter(delegate: self)
        setupView()
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
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func logoutProfile(alertModel: LogoutAlertModel) {
        logoutAlertPresenter?.requestShowLogoutAlert(alertModel: alertModel)
    }
    
    func showAlertGetAvatarError(alertModel: ErrorAlertModel) {
        errorAlertPresenter?.requestShowResultAlert(alertModel: alertModel)
    }
}

extension ProfileViewController: ErrorAlertPresenterDelegate {
    func showErrorAlert(alertController: UIAlertController?) {
        guard let alertController = alertController else { return }
        present(alertController, animated: true)
    }
}

extension ProfileViewController: LogoutAlertPresenterDelegate {
    func showLogoutAlert(alertController: UIAlertController?) {
        guard let alertController = alertController else { return }
        present(alertController, animated: true)
    }
}
