import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}


/// WebView presenter
final class WebViewPresenter {
    
    var view: WebViewViewControllerProtocol?
    
    // MARK: - Constants
    private struct WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let responseType = "code"
    }
}

// MARK: WebViewPresenterProtocol, viewDidLoad
extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        guard let request = createRequest() else {
            assertionFailure("Ошибка запроса для авторизации")
            return
        }
        didUpdateProgressValue(0)
        view?.load(request: request)
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

// MARK: WebViewPresenterProtocol, UpdateProgress
extension WebViewPresenter {
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHiden(shouldHideProgress)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}


// MARK: WebViewPresenterProtocol, code
extension WebViewPresenter {
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        }
        return nil
    }
}
