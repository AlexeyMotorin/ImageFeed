import UIKit
import WebKit

/// С помощью протокола делегируем обработку кода и закрытие экрана
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

/// Класс отвечает за отображение окна для авторизации пользователя и перехвата параметра code необходимого для авторизации пользователя
final class WebViewViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Public properties
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Constants
    private struct WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let responseType = "code"
        static let urlComponentsPath = "/oauth/authorize/native"
    }
    
    // MARK: - Private properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let request = createRequest() else {
            fatalError("Ошибка запроса для авторизации")
        }
        
        webView.load(request)
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
        
    // MARK: - IBAction
    @IBAction func didTabBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Private methods
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
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
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    /// Фунция получения кода для авторизации
    /// - Parameter navigationAction: navigationAction который получаем из метода (_ webView: , decidePolicyFor : , decisionHandler: ), получаем из него url, который разбираем на компоненты
    /// - Returns: нужный код для авторизации пользователя
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebViewConstants.urlComponentsPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
