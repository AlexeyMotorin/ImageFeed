import UIKit

protocol SharingPresenterDelegate: AnyObject {
    func shareImage(viewController: UIActivityViewController?)
}
