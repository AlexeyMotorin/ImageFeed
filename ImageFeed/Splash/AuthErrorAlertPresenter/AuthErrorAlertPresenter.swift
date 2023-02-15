import UIKit

final class AuthErrorAlertPresenter {
    private weak var delegate: AuthErrorAlertPresenterDelegate?
    
    init(delegate: AuthErrorAlertPresenterDelegate) {
        self.delegate = delegate
    }
}

extension AuthErrorAlertPresenter: AuthErrorAlertPresenterProtocol {
    func requestShowResultAlert(alertModel: AuthErrorAlertModel?) {
        let vc = UIAlertController(title: alertModel?.title, message: alertModel?.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel?.buttonText, style: .default)
        vc.addAction(action)
        delegate?.showErrorAlert(alertController: vc)
    }
    
}
