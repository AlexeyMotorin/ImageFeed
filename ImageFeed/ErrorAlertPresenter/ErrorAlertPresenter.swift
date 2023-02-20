import UIKit

final class ErrorAlertPresenter {
    private weak var delegate: ErrorAlertPresenterDelegate?
    
    init(delegate: ErrorAlertPresenterDelegate) {
        self.delegate = delegate
    }
}

extension ErrorAlertPresenter: ErrorAlertPresenterProtocol {
    func requestShowResultAlert(alertModel: ErrorAlertModel?) {
        let vc = UIAlertController(title: alertModel?.title, message: alertModel?.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel?.buttonText, style: .default)
        vc.addAction(action)
        delegate?.showErrorAlert(alertController: vc)
    }
    
}
