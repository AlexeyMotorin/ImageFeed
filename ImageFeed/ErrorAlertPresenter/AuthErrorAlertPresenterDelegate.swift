import UIKit

protocol ErrorAlertPresenterDelegate: AnyObject {
    func showErrorAlert(alertController: UIAlertController?)
}
