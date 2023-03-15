import UIKit

final class LogoutAlertPresenter {
    private weak var delegate: LogoutAlertPresenterDelegate?
    
    init(delegate: LogoutAlertPresenterDelegate) {
        self.delegate = delegate
    }
}

extension LogoutAlertPresenter: LogoutAlertPresenterProtocol {
    func requestShowLogoutAlert(alertModel: LogoutAlertModel?) {
        let vc = UIAlertController(title: alertModel?.title, message: alertModel?.message, preferredStyle: .alert)
        vc.view.accessibilityIdentifier = "bye bye!"
        let yesAction = UIAlertAction(title: alertModel?.buttonText, style: .default, handler: alertModel?.completion)
        yesAction.accessibilityIdentifier = "Yes"
        let noAction = UIAlertAction(title: "Нет", style: .default)
        vc.addAction(yesAction)
        vc.addAction(noAction)
        delegate?.showLogoutAlert(alertController: vc)
    }
}
