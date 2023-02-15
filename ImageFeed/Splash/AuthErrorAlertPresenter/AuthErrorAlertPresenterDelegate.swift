import UIKit

protocol AuthErrorAlertPresenterDelegate: AnyObject {
    func showErrorAlert(alertController: UIAlertController?)
}
