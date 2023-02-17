
import UIKit

protocol SingleImageViewControllerProtocol: AnyObject {
    func dismissViewController()
    func sharingImage(_ image: UIImage?)
}

final class SingleImageViewController: UIViewController {
    
    // MARK: - Private properties
    private var sharingPresenter: SharingPresenterProtocol!
    private var singleImageScreen: SingleImageViewControllerScreen!
    
    // MARK: - Public properties
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageScreen.setImage(image)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageScreen = SingleImageViewControllerScreen(viewController: self)
        sharingPresenter = SharingPresenter(delegate: self)
        setScreenViewOnViewController(view: singleImageScreen)
        singleImageScreen.setImage(image)
    }
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - SharingPresenterDelegate
extension SingleImageViewController: SharingPresenterDelegate {
    func shareImage(viewController: UIActivityViewController?) {
        guard let viewController else { return }
        present(viewController, animated: true)
    }
}

extension SingleImageViewController: SingleImageViewControllerProtocol {
    func dismissViewController() {
        dismiss(animated: true)
    }
    
    func sharingImage(_ image: UIImage?) {
        sharingPresenter.requestSharingImage(for: image)
    }
}

