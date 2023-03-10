import UIKit
import WebKit

/// С помощью протокола делегируем обработку кода и закрытие экрана
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    func dismissViewController()
    func getCode(code: String?)
}

/// Класс отвечает за отображение окна для авторизации пользователя и перехвата параметра code необходимого для авторизации пользователя
final class WebViewViewController: UIViewController {
        
    // MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
  
    // MARK: - Private properties
    private var webviewScreen: WebViewView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewScreen = WebViewView(frame: .zero, viewController: self)
        setScreenViewOnViewController(view: webviewScreen)
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
