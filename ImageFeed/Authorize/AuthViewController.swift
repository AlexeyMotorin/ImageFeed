import UIKit

/// Контроллер авторизации пользователя
final class AuthViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Override methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
}
