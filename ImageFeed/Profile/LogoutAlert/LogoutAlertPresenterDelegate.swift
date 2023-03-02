import UIKit

protocol LogoutAlertPresenterDelegate: AnyObject {
    func showLogoutAlert(alertController: UIAlertController?)
}
