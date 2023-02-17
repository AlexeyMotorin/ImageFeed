import UIKit
import WebKit

/// С помощью протокола делегируем обработку кода и закрытие экрана
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    func dismissViewController()
    func getCode(code: String)
}

/// Класс отвечает за отображение окна для авторизации пользователя и перехвата параметра code необходимого для авторизации пользователя
final class WebViewViewController: UIViewController {
        
    // MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Constants
    private struct WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let responseType = "code"
    }
    
    // MARK: - Private properties
    
    private var webviewScreen: WebViewControllerScreen!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewScreen = WebViewControllerScreen(viewController: self)
        setScreenViewOnViewController(view: webviewScreen)
        
        guard let request = createRequest() else {
            fatalError("Ошибка запроса для авторизации")
        }
        
        webviewScreen.loadWebview(request: request)
    }
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
            
    // MARK: - Private methods

    
    private func createRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: WebViewConstants.responseType),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    deinit {
       print("WebViewViewController deinit")
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
 
}

extension WebViewViewController: WebViewViewControllerProtocol {
    func getCode(code: String) {
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
    }
    
    func dismissViewController() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}
