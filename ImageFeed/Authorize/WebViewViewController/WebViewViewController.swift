import UIKit
import WebKit

/// С помощью протокола делегируем обработку кода и закрытие экрана
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHiden(_ isHidden: Bool)
    
    func dismissViewController()
    func getCode(code: String?)
}

/// Класс отвечает за отображение окна для авторизации пользователя и перехвата параметра code необходимого для авторизации пользователя
final class WebViewViewController: UIViewController {
        
    // MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Private properties
    private var webviewScreen: WebViewControllerScreen!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewScreen = WebViewControllerScreen(viewController: self)
        setScreenViewOnViewController(view: webviewScreen)

        presenter?.viewDidLoad()
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
    func setProgressValue(_ newValue: Float) {
        webviewScreen.setProgressValue(newValue)
    }
    
    func setProgressHiden(_ isHidden: Bool) {
        webviewScreen.setProgressHiden(isHidden)
    }
    
    func load(request: URLRequest) {
        webviewScreen.loadWebview(request: request)
    }
    
    func getCode(code: String?) {
        guard let code = code else { return }
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
    }
    
    func dismissViewController() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}
