import UIKit
import WebKit

/// С помощью протокола делегируем обработку кода и закрытие экрана
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    var webviewScreen: WebViewViewProtocol? { get set}
    func dismissViewController()
    func getCode(code: String?)
}

/// Класс отвечает за отображение окна для авторизации пользователя и перехвата параметра code необходимого для авторизации пользователя
final class WebViewViewController: UIViewController {
        
    // MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
  
    // MARK: - Private properties
    var webviewScreen: WebViewViewProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewScreen = WebViewView(frame: .zero, viewController: self)
        
        guard let screenView = webviewScreen as? UIView else { return }
        setScreenViewOnViewController(view: screenView)
    }
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension WebViewViewController: WebViewViewControllerProtocol {
  
    func getCode(code: String?) {
        guard let code = code else { return }
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
    }
    
    func dismissViewController() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}
